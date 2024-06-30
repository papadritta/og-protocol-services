#!/bin/bash

exists() {
  command -v "$1" >/dev/null 2>&1
}

is_port_in_use() {
  ss -tulpen | awk '{print $5}' | grep -q ":$1$"
}

set_env_var() {
  local var_name="$1"
  local var_value="$2"
  if grep -q "export $var_name=" ~/.bash_profile; then
    sed -i.bak "/export $var_name=/c\export $var_name=\"$var_value\"" ~/.bash_profile
  else
    echo "export $var_name=\"$var_value\"" >> ~/.bash_profile
  fi
}

cleanup_previous_installation() {
  echo "Cleaning up previous installation..."

  sudo systemctl stop zgs || true
  sudo systemctl disable zgs || true

  sudo rm -f /etc/systemd/system/zgs.service

  rm -rf $HOME/0g-storage-node

  sed -i.bak '/ZGS_CONFIG_FILE/d' ~/.bash_profile
  sed -i.bak '/ZGS_LOG_DIR/d' ~/.bash_profile
  sed -i.bak '/ZGS_LOG_CONFIG_FILE/d' ~/.bash_profile
  sed -i.bak '/ZGS_CONTRACT_ADDRESS/d' ~/.bash_profile
  sed -i.bak '/ZGS_MINE_CONTRACT/d' ~/.bash_profile
  sed -i.bak '/ZGS_LOG_SYNC_BLOCK/d' ~/.bash_profile
  sed -i.bak '/ZGS_RPC/d' ~/.bash_profile
  source ~/.bash_profile
}

if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

bash_profile="$HOME/.bash_profile"
if [ -f "$bash_profile" ]; then
    . "$bash_profile"
fi

source <(curl -s https://raw.githubusercontent.com/papadritta/scripts/main/main.sh)

printLogo

printCyan() {
  echo -e "\e[96m$1\e[0m"
}

printCyan "Starting installation script..."

cleanup_previous_installation

printCyan "Updating packages..." && sleep 1
sudo apt-get update

printCyan "Installing dependencies..." && sleep 1
sudo apt-get install -y clang cmake build-essential git cargo

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

if ! exists rustup; then
  printCyan "Installing Rustup..." && sleep 1
  curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
  source $HOME/.cargo/env
else
  printCyan "Rustup is already installed. Version:" && sleep 1
  rustup --version
fi

printCyan "Cloning 0G Storage Node repository..." && sleep 1
git clone -b v0.3.2 https://github.com/0glabs/0g-storage-node.git

printCyan "Building the project..." && sleep 1
cd $HOME/0g-storage-node
git checkout tags/v0.3.2
git submodule update --init
cargo build --release

printCyan "Setting up environment variables..." && sleep 1
set_env_var "ZGS_LOG_DIR" "$HOME/0g-storage-node/run/log"
set_env_var "ZGS_LOG_CONFIG_FILE" "$HOME/0g-storage-node/run/log_config"
set_env_var "ZGS_CONFIG_FILE" "$HOME/0g-storage-node/run/config.toml"
set_env_var "ZGS_CONTRACT_ADDRESS" "0x8873cc79c5b3b5666535C825205C9a128B1D75F1"
set_env_var "ZGS_MINE_CONTRACT" "0x85F6722319538A805ED5733c5F4882d96F1C7384"
set_env_var "ZGS_LOG_SYNC_BLOCK" "802"
set_env_var "WATCH_LOOP_WAIT_TIME_MS" "1000"
set_env_var "WALLET_STORAGE" "storage"
set_env_var "ZGS_RPC" "https://rpc-og.papadritta.com"
source ~/.bash_profile

ZGS_IP=$(wget -qO- eth0.me)

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
s|# watch_loop_wait_time_ms = 500|watch_loop_wait_time_ms = 15000|g
s|network_enr_address = ""|network_enr_address = "'"$ZGS_IP"'"|g
' $HOME/0g-storage-node/run/config.toml

sed -i '
s|^log_sync_start_block_number = .*|log_sync_start_block_number = '"$ZGS_LOG_SYNC_BLOCK"'|g
s|^log_config_file = .*|log_config_file = "'"$ZGS_LOG_CONFIG_FILE"'"|g
s|^log_directory = .*|log_directory = "'"$ZGS_LOG_DIR"'"|g
s|^mine_contract_address = .*|mine_contract_address = "'"$ZGS_MINE_CONTRACT"'"|g
s|^log_contract_address = .*|log_contract_address = "'"$ZGS_CONTRACT_ADDRESS"'"|g
s|^watch_loop_wait_time_ms = .*|watch_loop_wait_time_ms = '"$WATCH_LOOP_WAIT_TIME_MS"'|g
s|^blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = '"\"$ZGS_RPC\""'|g
' $HOME/0g-storage-node/run/config.toml

update_config() {
  local private_key="$1"
  local config_file="$HOME/0g-storage-node/run/config.toml"

  if grep -q '^miner_key = ".*"' "$config_file"; then
    sed -i 's|^miner_key = ".*"|miner_key = "'"$private_key"'"|' "$config_file"
  else
    echo 'miner_key = "'"$private_key"'"' >> "$config_file"
  fi

  if grep -q "miner_key = \"$private_key\"" "$config_file"; then
    echo "Config file updated successfully."
  else
    echo "Failed to update the config file."
    exit 1
  fi
}

source ~/.bash_profile

if [ -z "$WALLET_STORAGE" ]; then
  echo "WALLET_STORAGE environment variable is not set. Setting it now..."
  WALLET_STORAGE="storage"
  echo "export WALLET_STORAGE=\"$WALLET_STORAGE\"" >> ~/.bash_profile
  source ~/.bash_profile

  printCyan "Adding key for storage wallet..." && sleep 1
  KEY_OUTPUT=$(0gchaind keys add $WALLET_STORAGE --eth --keyring-backend test)
  echo "$KEY_OUTPUT"

  printCyan "Extracting and storing private key for storage node..." && sleep 1
  PRIVATE_KEY=$(0gchaind keys unsafe-export-eth-key $WALLET_STORAGE --keyring-backend test)
  if [ -z "$PRIVATE_KEY" ]; then
    echo "Failed to extract the private key. Please check if the wallet name is correct and exists."
    exit 1
  fi

  update_config "$PRIVATE_KEY"
else

  WALLET_INFO=$(0gchaind keys list --keyring-backend test | grep -A 3 "name: $WALLET_STORAGE")

  if [ -z "$WALLET_INFO" ]; then
    printCyan "Wallet storage not found. Adding key for storage wallet..." && sleep 1
    KEY_OUTPUT=$(0gchaind keys add $WALLET_STORAGE --eth --keyring-backend test)
    echo "$KEY_OUTPUT"

    printCyan "Extracting and storing private key for storage node..." && sleep 1
    PRIVATE_KEY=$(0gchaind keys unsafe-export-eth-key $WALLET_STORAGE --keyring-backend test)
    if [ -z "$PRIVATE_KEY" ]; then
      echo "Failed to extract the private key. Please check if the wallet name is correct and exists."
      exit 1
    fi

    update_config "$PRIVATE_KEY"
  else
    printCyan "Wallet storage already exists. Debugging wallet information..." && sleep 1
    echo "$WALLET_INFO"

    PUBLIC_KEY=$(echo "$WALLET_INFO" | grep -oP '(?<=ethsecp256k1.PubKey","key":").*(?="})')
    ADDRESS=$(echo "$WALLET_INFO" | grep -oP '(?<=- address: ).*')

    echo "Public Key: $PUBLIC_KEY"
    echo "Address: $ADDRESS"

    PRIVATE_KEY=$(0gchaind keys unsafe-export-eth-key $WALLET_STORAGE --keyring-backend test)
    update_config "$PRIVATE_KEY"
  fi
fi

source ~/.bash_profile

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

printCyan "Check ZGS Node status..." && sleep 1
if sudo systemctl status zgs | grep -q "active (running)"; then
  echo "Your ZGS Node is installed and works!"
  echo "You can check ZGS Node status by the command 'sudo systemctl status zgs'"
  echo "You can check ZGS Logs by the command 'sudo journalctl -u zgs -f -o cat'"
else
  printf "Your ZGS Node was not installed correctly, please reinstall by running: ./storage.sh\n"
fi

printCyan "Check and save your node information:" && sleep 1
echo "WALLET_STORAGE: $WALLET_STORAGE"
echo "WALLET_ADDRESS: $(0gchaind keys show $WALLET_STORAGE -a --keyring-backend test)"
ADDRESS=$(0gchaind keys show $WALLET_STORAGE -a --keyring-backend test)
if [ -z "$ADDRESS" ]; then
  echo "Failed to get the address for storage wallet."
  exit 1
fi
DEBUG_OUTPUT=$(0gchaind debug addr $ADDRESS)
if [ $? -ne 0 ]; then
  echo "Failed to debug the address."
  exit 1
fi
HEX_ADDRESS=$(echo "$DEBUG_OUTPUT" | grep hex | awk '{print $3}')
if [ -z "$HEX_ADDRESS" ]; then
  echo "Failed to extract hex address."
  exit 1
fi
echo "ADDRESS_FOR_FAUCET: 0x$HEX_ADDRESS"
echo "PRIVATE_KEY (SAVE IT): $PRIVATE_KEY"
echo "ZGS_RPC: $ZGS_RPC"
echo "ZGS_CONTRACT_ADDRESS: $ZGS_CONTRACT_ADDRESS"
echo "ZGS_MINE_CONTRACT: $ZGS_MINE_CONTRACT"

printCyan "What next?" && sleep 1
echo -e "\nRequest tokens from faucet: https://faucet.0g.ai"
printCyan "Your address for Faucet is" && sleep 1
echo "0x$HEX_ADDRESS"
printCyan "After requesting tokens from the faucet: Restart the service" && sleep 1
echo -e "\nsudo systemctl start zgs"

printCyan "Next - CHECK & MONITOR STORAGE NODE LOGS and you are DONE!!!" && sleep 1
echo -e "\tail -f ~/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)"

printf "\nTo re-run the script again, use: ./storage.sh\e[0m\n"