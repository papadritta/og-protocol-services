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

  sudo systemctl stop zgskv || true
  sudo systemctl disable zgskv || true

  sudo rm -f /etc/systemd/system/zgskv.service

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

source <(curl -s https://raw.githubusercontent.com/papadritta/scripts/main/main.sh)

printLogo

printCyan() {
  echo -e "\e[96m$1\e[0m"
}

printCyan "Starting installation script..."

cleanup_previous_installation
sudo systemctl daemon-reload

printCyan "Updating packages..." && sleep 1
sudo apt-get update

printCyan "Installing dependencies..." && sleep 1
sudo apt-get install -y clang cmake build-essential git cargo

printCyan "Cloning 0G Storage KV repository..." && sleep 1
REPO_URL="https://github.com/0glabs/0g-storage-kv.git"
INSTALL_DIR="$HOME/0g-storage-kv"
git clone $REPO_URL $INSTALL_DIR

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
BLOCK_NUMBER=$(grep "log_sync_start_block_number" "$HOME/0g-storage-node/run/config.toml" | cut -d' ' -f3)

printCyan "Setting up environment variables..." && sleep 1
set_env_var "DB_DIR" "$HOME/0g-storage-kv/db"
set_env_var "ZGSKV_DB_DIR" "$HOME/0g-storage-kv/kv-db"
set_env_var "ZGS_NODE_URLS" "http://127.0.0.1:5678"
set_env_var "ZGSKV_CONFIG_FILE" "$HOME/0g-storage-kv/run/config.toml"
set_env_var "ZGSKV_LOG_CONFIG_FILE" "$HOME/0g-storage-kv/run/log_config"
set_env_var "BLOCK_NUMBER" "$BLOCK_NUMBER"
source ~/.bash_profile

printCyan "Validating if the node URL is accessible..." && sleep 1
if nc -zv 127.0.0.1 5678; then
  echo "Your local storage node is reachable."
else
  echo "We can't reach your node."
fi

printCyan "Updating configuration file..." && sleep 1
sed -i "s|^\s*#\?\s*db_dir\s*=.*|db_dir = \"$DB_DIR\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|^\s*#\?\s*kv_db_dir\s*=.*|kv_db_dir = \"$ZGSKV_DB_DIR\"|" "$ZGSKV_CONFIG_FILE"
sed -i 's|^\s*#\?\s*rpc_listen_address\s*=.*|rpc_listen_address = "0.0.0.0:6789"|' "$ZGSKV_CONFIG_FILE"
sed -i "s|^\s*#\?\s*zgs_node_urls\s*=.*|zgs_node_urls = \"$ZGS_NODE_URLS\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|^\s*#\?\s*log_config_file\s*=.*|log_config_file = \"$ZGSKV_LOG_CONFIG_FILE\"|" "$ZGSKV_CONFIG_FILE"
sed -i "s|^\s*#\?\s*blockchain_rpc_endpoint\s*=.*|blockchain_rpc_endpoint = \"https://rpc-og.papadritta.com\"|" "$ZGSKV_CONFIG_FILE"
sed -i 's|^\s*#\?\s*log_contract_address\s*=.*|log_contract_address = "0xb8F03061969da6Ad38f0a4a9f8a86bE71dA3c8E7"|' "$ZGSKV_CONFIG_FILE"
sed -i "s|^\s*#\?\s*log_sync_start_block_number\s*=.*|log_sync_start_block_number = $BLOCK_NUMBER|" "$ZGSKV_CONFIG_FILE"

printCyan "Creating systemd service file..." && sleep 1
SERVICE_FILE="/etc/systemd/system/zgskv.service"
sudo tee $SERVICE_FILE > /dev/null <<EOF
[Unit]
Description=0G Storage KV Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=$BIN_DIR/zgs_kv --config $INSTALL_DIR/run/config.toml
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

printCyan "Reloading systemd, enabling and starting the service..." && sleep 1
sudo systemctl daemon-reload
sudo systemctl enable zgskv
sudo systemctl start zgskv

printCyan "Check ZGSKV Node status..." && sleep 1
if sudo systemctl status zgskv | grep -q "active (running)"; then
  echo "Your ZGSKV Node is installed and works!"
  echo "You can check ZGSKV Node status by the command 'sudo systemctl status zgskv'"
  echo "You can check ZGSKV Logs by the command 'sudo journalctl -u zgskv -f -o cat'"
else
  printf "Your ZGSKV Node was not installed correctly, please reinstall by running: ./storage-kv.sh\n"
fi

printCyan "Next - CHECK & MONITOR STORAGE-KV NODE LOGS and you are DONE!!!" && sleep 1

printf "\nTo re-run the script again, use: ./storage-kv.sh\e[0m\n"