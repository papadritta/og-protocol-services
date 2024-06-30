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

  sudo systemctl stop zgs-kv || true
  sudo systemctl disable zgs-kv || true

  sudo rm -f /etc/systemd/system/zgs-kv.service

  rm -rf $HOME/0g-storage-kv

  sed -i.bak '/DB_DIR/d' ~/.bash_profile
  sed -i.bak '/ZGSKV_DB_DIR/d' ~/.bash_profile
  sed -i.bak '/ZGS_NODE_URLS/d' ~/.bash_profile
  sed -i.bak '/ZGSKV_CONFIG_FILE/d' ~/.bash_profile
  sed -i.bak '/ZGSKV_LOG_CONFIG_FILE/d' ~/.bash_profile
  sed -i.bak '/BLOCK_NUMBER/d' ~/.bash_profile
  source ~/.bash_profile
}

if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

bash_profile="$HOME/.bash_profile"
if [ -f "$bash_profile" ]; then
    . "$bash_profile"
fi

# Source external script for printing logo
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

printCyan "Cloning 0G Storage KV repository..." && sleep 1
REPO_URL="https://github.com/0glabs/0g-storage-kv.git"
INSTALL_DIR="$HOME/0g-storage-kv"
git clone -b v1.1.0-testnet $REPO_URL $INSTALL_DIR

printCyan "Building the project..." && sleep 1
cd $INSTALL_DIR
git submodule update --init
cargo build --release

printCyan "Moving the built binary to /usr/local/bin..." && sleep 1
BIN_DIR="/usr/local/bin"
sudo mv "$INSTALL_DIR/target/release/zgs_kv" $BIN_DIR

printCyan "Creating necessary directories..." && sleep 1
mkdir -p "$INSTALL_DIR/db" "$INSTALL_DIR/kv-db"

printCyan "Copying config file..." && sleep 1
cp "$INSTALL_DIR/run/config_example.toml" "$INSTALL_DIR/run/config.toml"

printCyan "Fetching required environment variables..." && sleep 1
STORAGE_PORT=$(grep -oP '(?<=rpc_listen_address = "0.0.0.0:)\d+(?=")' $HOME/0g-storage-node/run/config.toml)
ZGS_LOG_SYNC_BLOCK=$(grep -oP '(?<=log_sync_start_block_number = )\d+' $HOME/0g-storage-node/run/config.toml)
STORAGE_RPC_ENDPOINT=http://$(wget -qO- eth0.me):$STORAGE_PORT
BLOCKCHAIN_RPC_ENDPOINT=$(sed -n 's/blockchain_rpc_endpoint = "\([^"]*\)"/\1/p' $HOME/0g-storage-node/run/config.toml)
LOG_CONTRACT_ADDRESS=$(sed -n 's/log_contract_address = "\([^"]*\)"/\1/p' $HOME/0g-storage-node/run/config.toml)
MINE_CONTRACT_ADDRESS=$(sed -n 's/mine_contract_address = "\([^"]*\)"/\1/p' $HOME/0g-storage-node/run/config.toml)
JSON_PORT=$(sed -n '/\[json-rpc\]/,/^address/ s/address = "0.0.0.0:\([0-9]*\)".*/\1/p' $HOME/.0gchain/config/app.toml)
JSON_RPC_ENDPOINT=http://$(wget -qO- eth0.me):$JSON_PORT

printCyan "Fetched environment variables:"
echo "STORAGE_PORT: $STORAGE_PORT"
echo "ZGS_LOG_SYNC_BLOCK: $ZGS_LOG_SYNC_BLOCK"
echo "STORAGE_RPC_ENDPOINT: $STORAGE_RPC_ENDPOINT"
echo "BLOCKCHAIN_RPC_ENDPOINT: $BLOCKCHAIN_RPC_ENDPOINT"
echo "LOG_CONTRACT_ADDRESS: $LOG_CONTRACT_ADDRESS"
echo "MINE_CONTRACT_ADDRESS: $MINE_CONTRACT_ADDRESS"
echo "JSON_PORT: $JSON_PORT"
echo "JSON_RPC_ENDPOINT: $JSON_RPC_ENDPOINT"

printCyan "Setting up environment variables..." && sleep 1
set_env_var "DB_DIR" "$HOME/0g-storage-kv/db"
set_env_var "ZGSKV_DB_DIR" "$HOME/0g-storage-kv/kv-db"
set_env_var "ZGS_NODE_URLS" "$STORAGE_RPC_ENDPOINT"
set_env_var "ZGSKV_CONFIG_FILE" "$HOME/0g-storage-kv/run/config.toml"
set_env_var "ZGSKV_LOG_CONFIG_FILE" "$HOME/0g-storage-kv/run/log_config"
set_env_var "BLOCK_NUMBER" "$ZGS_LOG_SYNC_BLOCK"
source ~/.bash_profile

printCyan "Updating configuration file..." && sleep 1
sed -i "s|rpc_listen_address = .*|rpc_listen_address = \"0.0.0.0:6789\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|zgs_node_urls = .*|zgs_node_urls = \"$STORAGE_RPC_ENDPOINT\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|log_config_file = .*|log_config_file = \"$ZGSKV_LOG_CONFIG_FILE\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|blockchain_rpc_endpoint = .*|blockchain_rpc_endpoint = \"$BLOCKCHAIN_RPC_ENDPOINT\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|log_contract_address = .*|log_contract_address = \"$LOG_CONTRACT_ADDRESS\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|log_sync_start_block_number = .*|log_sync_start_block_number = $ZGS_LOG_SYNC_BLOCK|" "$ZGSKV_CONFIG_FILE"

printCyan "Creating systemd service file..." && sleep 1
SERVICE_FILE="/etc/systemd/system/zgs-kv.service"
sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=ZGS-KV Node
After=network.target

[Service]
User=$USER
WorkingDirectory=$HOME/0g-storage-kv/run
ExecStart=$BIN_DIR/zgs_kv --config $HOME/0g-storage-kv/run/config.toml
Restart=on-failure
RestartSec=10
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

printCyan "Reloading systemd, enabling and starting the service..." && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable zgs-kv
sudo systemctl start zgs-kv

printCyan "Check ZGS-KV Node status..." && sleep 1
if sudo systemctl status zgs-kv | grep -q "active (running)"; then
  echo "Your ZGS-KV Node is installed and works!"
  echo "You can check ZGS-KV Node status by the command 'sudo systemctl status zgs-kv'"
  echo "You can check ZGS-KV Logs by the command 'sudo journalctl -u zgs-kv -f -o cat'"
else
  printf "Your ZGS-KV Node was not installed correctly, please reinstall by running: ./storage-kv.sh\n"
fi