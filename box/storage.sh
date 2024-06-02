#!/bin/bash

# Function to check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

# Check curl is installed
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

# System updates and installation of required environments
printCyan "Updating packages..." && sleep 1
sudo apt-get update

printCyan "Installing dependencies..." && sleep 1
sudo apt-get install -y clang cmake build-essential

# Install Go if not already installed
if ! exists go; then
  printCyan "Installing Golang..." && sleep 1
  cd $HOME
  ver="1.22.0"
  wget "https://go.dev/dl/go$ver.linux-amd64.tar.gz"
  sudo rm -rf /usr/local/go
  sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz"
  rm "go$ver.linux-amd64.tar.gz"
  echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile
  source ~/.bash_profile
fi

# Install Rustup
printCyan "Installing Rustup..." && sleep 1
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh -s -- -y
source $HOME/.cargo/env

# Clone the 0G Storage Node repository
printCyan "Cloning 0G Storage Node repository..." && sleep 1
git clone -b v0.2.0 https://github.com/0glabs/0g-storage-node.git

# Build the project
printCyan "Building the project..." && sleep 1
cd $HOME/0g-storage-node
git submodule update --init
sudo apt install -y cargo
cargo build --release

# Set up environment variables
printCyan "Setting up environment variables..." && sleep 1
echo 'export ZGS_CONFIG_FILE="$HOME/0g-storage-node/run/config.toml"' >> ~/.bash_profile
echo 'export ZGS_LOG_DIR="$HOME/0g-storage-node/run/log"' >> ~/.bash_profile
echo 'export ZGS_LOG_CONFIG_FILE="$HOME/0g-storage-node/run/log_config"' >> ~/.bash_profile
echo 'export LOG_CONTRACT_ADDRESS="0x2b8bC93071A6f8740867A7544Ad6653AdEB7D919"' >> ~/.bash_profile
echo 'export MINE_CONTRACT="0x228aCfB30B839b269557214216eA4162db24445d"' >> ~/.bash_profile
echo 'export WALLET_STORAGE="storage"' >> ~/.bash_profile
source ~/.bash_profile

# Option A: Extract and store private key if running storage on the same server with Validator node
printCyan "Extracting and storing private key for storage node..." && sleep 1
0gchaind keys unsafe-export-eth-key $WALLET_STORAGE
read -sp "Enter your private key: " PRIVATE_KEY && echo
sed -i 's|miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml

# Update config.toml
printCyan "Updating config.toml..." && sleep 1
sed -i 's|# log_config_file = "log_config"|log_config_file = "'"$ZGS_LOG_CONFIG_FILE"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_directory = "log"|log_directory = "'"$ZGS_LOG_DIR"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|mine_contract_address = ".*"|mine_contract_address = "'"$MINE_CONTRACT"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|log_contract_address = ".*"|log_contract_address = "'"$LOG_CONTRACT_ADDRESS"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|blockchain_rpc_endpoint = "https://rpc-testnet.0g.ai"|blockchain_rpc_endpoint = "https://rpc-og.papadritta.com"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_dir = "network"|network_dir = "network"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_libp2p_port = 1234|network_libp2p_port = 1234|' $HOME/0g-storage-node/run/config.toml
sed -i 's|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmPxGNWu9eVAQPJww79J32pTJLKGcpjRMb4Qb8xxKkyuG1","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAm93Hd5azfhkGBbkx1zero3nYHvfjQYM2NtiW4R3r5bE2g"\]|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS"\]|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# db_dir = "db"|db_dir = "db"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|blockchain_rpc_endpoint = ".*"|blockchain_rpc_endpoint = "https://rpc-og.papadritta.com"|' $HOME/0g-storage-node/run/config.toml

# Create Service File
printCyan "Creating service file..." && sleep 1
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-node/run
ExecStart=$HOME/0g-storage-node/target/release/zgs_node --config $HOME/0g-storage-node/run/config.toml
Environment="ZGS_CONFIG_FILE=$HOME/0g-storage-node/run/config.toml"
Environment="ZGS_LOG_DIR=$HOME/0g-storage-node/run/log"
Environment="ZGS_LOG_CONFIG_FILE=$HOME/0g-storage-node/run/log_config"
StandardOutput=journal
StandardError=journal
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

# Service execution
printCyan "Starting service..." && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable zgs
sudo systemctl start zgs

# Check service status
printCyan "Check ZGS Node status..." && sleep 1
if systemctl is-active --quiet zgs; then
  printf "Your ZGS Node is installed and works!\n"
  printf "You can check ZGS Node status by the command 'sudo systemctl status zgs'\n"
  printf "You can check ZGS Logs by the command 'sudo journalctl -u zgs -f -o cat'\n"
else
  printf "Your ZGS Node was not installed correctly, please reinstall.\n"
fi

# Check the latest log
printCyan "Checking the latest log..." && sleep 1
LATEST_LOG=$(ls -Art ~/0g-storage-node/run/log/ | tail -n 1)
cat ~/0g-storage-node/run/log/$LATEST_LOG | tail -n 100 | tac
