#!/bin/bash

# Function to check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if a port is in use
is_port_in_use() {
  ss -tulpen | awk '{print $5}' | grep -q ":$1$"
}

# Function to set environment variable if not already set
set_env_var() {
  local var_name="$1"
  local var_value="$2"
  if grep -q "export $var_name=" ~/.bash_profile; then
    sed -i.bak "/export $var_name=/c\export $var_name=\"$var_value\"" ~/.bash_profile
  else
    echo "export $var_name=\"$var_value\"" >> ~/.bash_profile
  fi
}

# Function to clean up previous installation
cleanup_previous_installation() {
  echo "Cleaning up previous installation..."

  # Stop and disable systemd service
  sudo systemctl stop zgs || true
  sudo systemctl disable zgs || true

  # Remove the systemd service file
  sudo rm -f /etc/systemd/system/zgs.service

  # Remove the project directory
  rm -rf $HOME/0g-storage-node

  # Remove environment variables
  sed -i.bak '/ZGS_CONFIG_FILE/d' ~/.bash_profile
  sed -i.bak '/ZGS_LOG_DIR/d' ~/.bash_profile
  sed -i.bak '/ZGS_LOG_CONFIG_FILE/d' ~/.bash_profile
  sed -i.bak '/ZGS_CONTRACT_ADDRESS/d' ~/.bash_profile
  sed -i.bak '/ZGS_MINE_CONTRACT/d' ~/.bash_profile
  sed -i.bak '/ZGS_LOG_SYNC_BLOCK/d' ~/.bash_profile
  sed -i.bak '/ZGS_RPC/d' ~/.bash_profile
  source ~/.bash_profile
}

# Check if curl is installed
if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

# Source the bash_profile if it exists
bash_profile="$HOME/.bash_profile"
if [ -f "$bash_profile" ]; then
    . "$bash_profile"
fi

source <(curl -s https://raw.githubusercontent.com/papadritta/scripts/main/main.sh)

printLogo

# Function to print in cyan color
printCyan() {
  echo -e "\e[96m$1\e[0m"
}

printCyan "Starting installation script..."

# Clean up previous installation
cleanup_previous_installation

# System updates and installation of required environments
printCyan "Updating packages..." && sleep 1
sudo apt-get update

printCyan "Installing dependencies..." && sleep 1
sudo apt-get install -y clang cmake build-essential git cargo

# Install Go if not already installed
if ! exists go; then
  printCyan "Installing Golang..." && sleep 1
  cd $HOME
  ver="1.22.0"
  wget "https://go.dev/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=\$PATH:/usr/local/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

# Install Rustup if not already installed 
if ! exists rustup; then
  printCyan "Installing Rustup..." && sleep 1
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
else
  printCyan "Rustup is already installed. Version:" && sleep 1
  rustup --version
fi

# Clone the 0G Storage Node repository 
printCyan "Cloning 0G Storage Node repository..." && sleep 1
git clone -b v0.2.0 https://github.com/0glabs/0g-storage-node.git

# Build the project
printCyan "Building the project..." && sleep 1
cd $HOME/0g-storage-node
git submodule update --init
cargo build --release

# Set up environment variables
printCyan "Setting up environment variables..." && sleep 1
set_env_var "ZGS_CONFIG_FILE" "$HOME/0g-storage-node/run/config.toml"
set_env_var "ZGS_LOG_DIR" "$HOME/0g-storage-node/run/log"
set_env_var "ZGS_LOG_CONFIG_FILE" "$HOME/0g-storage-node/run/log_config"
set_env_var "ZGS_CONTRACT_ADDRESS" "0x2b8bC93071A6f8740867A7544Ad6653AdEB7D919"
set_env_var "ZGS_MINE_CONTRACT" "0x228aCfB30B839b269557214216eA4162db24445d"
set_env_var "ZGS_LOG_SYNC_BLOCK" "334797"
set_env_var "ZGS_RPC" "https://rpc-og.papadritta.com"
set_env_var "WALLET_STORAGE" "storage"
source ~/.bash_profile

# Update the config
sed -i '
s|# network_dir = "network"|network_dir = "network"|
s|# network_enr_tcp_port = 1234|network_enr_tcp_port = 1234|
s|# network_enr_udp_port = 1234|network_enr_udp_port = 1234|
s|# network_libp2p_port = 1234|network_libp2p_port = 1234|
s|# network_discovery_port = 1234|network_discovery_port = 1234|
s|# rpc_enabled = true|rpc_enabled = true|
s|# db_dir = "db"|db_dir = "db"|
s|# log_config_file = "log_config"|log_config_file = "log_config"|
s|# log_directory = "log"|log_directory = "log"|
' $HOME/0g-storage-node/run/config.toml

sed -i '
s|^network_boot_nodes = \".*\"|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS"\]|
s|^log_contract_address = ".*"|log_contract_address = "'"$ZGS_CONTRACT_ADDRESS"'"|
s|^mine_contract_address = ".*"|mine_contract_address = "'"$ZGS_MINE_CONTRACT"'"|
s|^log_sync_start_block_number = .*|log_sync_start_block_number = '"$ZGS_LOG_SYNC_BLOCK"'|
s|^blockchain_rpc_endpoint = \".*|blockchain_rpc_endpoint = "'"$ZGS_RPC"'"|
' $HOME/0g-storage-node/run/config.toml

# Function to update miner_key in config.toml
update_config() {
  local private_key="$1"
  local config_file="$HOME/0g-storage-node/run/config.toml"

  # Check if miner_key exists and replace it, otherwise add it
  if grep -q '^miner_key = ".*"' "$config_file"; then
    sed -i 's|^miner_key = ".*"|miner_key = "'"$private_key"'"|' "$config_file"
  else
    echo 'miner_key = "'"$private_key"'"' >> "$config_file"
  fi

  # Verify the update
  if grep -q "miner_key = \"$private_key\"" "$config_file"; then
    echo "Config file updated successfully."
  else
    echo "Failed to update the config file."
    exit 1
  fi
}

# Load the .bash_profile to ensure environment variables are set
source ~/.bash_profile

# Check if WALLET_STORAGE is set, if not, set it and add the wallet
if [ -z "$WALLET_STORAGE" ]; then
  echo "WALLET_STORAGE environment variable is not set. Setting it now..."
  WALLET_STORAGE="storage"
  echo "export WALLET_STORAGE=\"$WALLET_STORAGE\"" >> ~/.bash_profile
  source ~/.bash_profile

  # Add key for storage wallet
  printCyan "Adding key for storage wallet..." && sleep 1
  KEY_OUTPUT=$(0gchaind keys add $WALLET_STORAGE --eth --keyring-backend=test)
  echo "$KEY_OUTPUT"

  # Extract and store private key for storage node
  printCyan "Extracting and storing private key for storage node..." && sleep 1
  PRIVATE_KEY=$(0gchaind keys unsafe-export-eth-key $WALLET_STORAGE)
  if [ -z "$PRIVATE_KEY" ]; then
    echo "Failed to extract the private key. Please check if the wallet name is correct and exists."
    exit 1
  fi

  update_config "$PRIVATE_KEY"
else
  # WALLET_STORAGE is set, check if the wallet already exists
  WALLET_INFO=$(0gchaind keys list --keyring-backend=test | grep -A 3 "name: $WALLET_STORAGE")

  if [ -z "$WALLET_INFO" ]; then
    printCyan "Wallet storage not found. Adding key for storage wallet..." && sleep 1
    KEY_OUTPUT=$(0gchaind keys add $WALLET_STORAGE --eth --keyring-backend=test)
    echo "$KEY_OUTPUT"

    # Extract and store private key for storage node
    printCyan "Extracting and storing private key for storage node..." && sleep 1
    PRIVATE_KEY=$(0gchaind keys unsafe-export-eth-key $WALLET_STORAGE)
    if [ -z "$PRIVATE_KEY" ]; then
      echo "Failed to extract the private key. Please check if the wallet name is correct and exists."
      exit 1
    fi

    update_config "$PRIVATE_KEY"
  else
    printCyan "Wallet storage already exists. Debugging wallet information..." && sleep 1
    echo "$WALLET_INFO"

    # Extract the public key and address for debugging purposes
    PUBLIC_KEY=$(echo "$WALLET_INFO" | grep -oP '(?<=ethsecp256k1.PubKey","key":").*(?="})')
    ADDRESS=$(echo "$WALLET_INFO" | grep -oP '(?<=- address: ).*')

    echo "Public Key: $PUBLIC_KEY"
    echo "Address: $ADDRESS"

    # Add the extracted private key to the config
    PRIVATE_KEY=$(0gchaind keys unsafe-export-eth-key $WALLET_STORAGE)
    update_config "$PRIVATE_KEY"
  fi
fi

# Reload the .bash_profile to ensure environment variables are set for future sessions
source ~/.bash_profile

# Creating and starting systemd service
printCyan "Creating service file..." && sleep 1
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

printCyan "Starting service..." && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable zgs
sudo systemctl start zgs

# Check ZGS Node status
printCyan "Check ZGS Node status..." && sleep 1
if sudo systemctl status zgs | grep -q "active (running)"; then
  echo "Your ZGS Node is installed and works!"
  echo "You can check ZGS Node status by the command 'sudo systemctl status zgs'"
  echo "You can check ZGS Logs by the command 'sudo journalctl -u zgs -f -o cat'"
else
  printf "Your ZGS Node was not installed correctly, please reinstall by running: ./storage.sh\n"
fi

# Print node information
printCyan "Check and save your node information:" && sleep 1
echo "WALLET_STORAGE: $WALLET_STORAGE"
echo "WALLET_ADDRESS: $(0gchaind keys show $WALLET_STORAGE -a)"
echo "ADDRESS_FOR_FAUCET: 0x$(0gchaind debug addr $(0gchaind keys show $WALLET_STORAGE -a) | grep hex | awk '{print $3}')"
echo "PRIVATE_KEY (SAVE IT): $PRIVATE_KEY"
echo "ZGS_RPC: $ZGS_RPC"
echo "ZGS_CONTRACT_ADDRESS: $ZGS_CONTRACT_ADDRESS"
echo "ZGS_MINE_CONTRACT: $ZGS_MINE_CONTRACT"

# Instructions for next step
printCyan "What next?" && sleep 1
echo -e "\nRequest tokens from faucet: https://faucet.0g.ai"
printCyan "Your address for Faucet is" && sleep 1
echo "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_STORAGE -a) | grep hex | awk '{print $3}')"
printCyan "After requesting tokens from the faucet: Restart the service" && sleep 1
echo -e "\nsudo systemctl start zgs"

printCyan "Next - CHECK & MONITOR STORAGE NODE LOGS and you are DONE!!!" && sleep 1

echo -e "\ntail -f $(ls ~/0g-storage-node/run/log/zgs.log.* | sort | tail -n 1)"

# Instructions for re-running the script
printf "\nTo re-run the script again, use: ./storage.sh\e[0m\n"

