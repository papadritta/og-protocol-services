#!/bin/bash

# Function to check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

# Function to check if a port is in use using ss command
is_port_in_use() {
  ss -tulpen | awk '{print $5}' | grep -q ":$1$"
}

# Function to adjust ports in config files
adjust_ports() {
  local config_path="$HOME/.0gchain/config/config.toml"
  local app_path="$HOME/.0gchain/config/app.toml"
  local client_path="$HOME/.0gchain/config/client.toml"

  if [[ -f "$config_path" && -f "$app_path" && -f "$client_path" ]]; then
    sed -i.bak -e "s%:26656%:$1%; s%:26657%:$2%; s%:26658%:$3%; s%:6060%:$4%; s%:1317%:$5%; s%:9090%:$6%; s%:9091%:$7%; s%:8545%:$8%; s%:8546%:$9%" "$config_path"
    sed -i.bak -e "s%:26656%:$1%; s%:26657%:$2%; s%:26658%:$3%; s%:6060%:$4%; s%:1317%:$5%; s%:9090%:$6%; s%:9091%:$7%; s%:8545%:$8%; s%:8546%:$9%" "$app_path"
    sed -i.bak -e "s%:26657%:$2%" "$client_path"
  else
    echo "Config files not found. Make sure the paths are correct."
    exit 1
  fi
}

# Function to print port bindings
print_ports() {
  echo "Ports for project $project_name:"
  echo "  RPC $rpc_port"
  echo "  RPC laddr $rpc_laddr_port"
  echo "  P2P $p2p_port"
  echo "  Prometheus $prometheus_port"
  echo "  API $api_port"
  echo "  gRPC $grpc_port"
  echo "  gRPC(web) $grpc_web_port"
  echo "  EVM RPC $evm_rpc_port"
  echo "  EVM RPC (ws) $evm_rpc_ws_port"
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

# Define default ports
base_rpc_port=26656
base_rpc_laddr_port=26657
base_p2p_port=26658
base_prometheus_port=6060
base_api_port=1317
base_grpc_port=9090
base_grpc_web_port=9091
base_evm_rpc_port=8545
base_evm_rpc_ws_port=8546

# Define constants
CHAIN_ID_OG="zgtendermint_16600-1"
DETAILS="OG to the >>> Moon"

# Source the bash_profile if it exists
bash_profile="$HOME/.bash_profile"
if [ -f "$bash_profile" ]; then
    . "$bash_profile"
fi

source <(curl -s https://raw.githubusercontent.com/papadritta/scripts/main/main.sh)

printLogo

# Prompt for required variables
while true; do
  read -p "Enter Validator name (MONIKER): " MONIKER
  if [ -n "$MONIKER" ]; then
    break
  else
    echo "Validator name (MONIKER) cannot be empty. Please enter a value."
  fi
done

while true; do
  read -p "Enter Wallet name (WALLET_NAME): " WALLET_NAME
  if [ -n "$WALLET_NAME" ]; then
    break
  else
    echo "Wallet name (WALLET_NAME) cannot be empty. Please enter a value."
  fi
done

# Prompt for optional variables
read -p "Enter Identity (IDENTITY, press ENTER to skip): " IDENTITY
read -p "Enter Website (WEBSITE, press ENTER to skip): " WEBSITE
read -p "Enter Email (EMAIL, press ENTER to skip): " EMAIL

# Set required environment variables
set_env_var "MONIKER" "$MONIKER"
set_env_var "WALLET_NAME" "$WALLET_NAME"
set_env_var "CHAIN_ID_OG" "$CHAIN_ID_OG"
set_env_var "DETAILS" "$DETAILS"

# Set optional environment variables
set_env_var "IDENTITY" "$IDENTITY"
set_env_var "WEBSITE" "$WEBSITE"
set_env_var "EMAIL" "$EMAIL"

# Source the updated bash profile
source ~/.bash_profile

# Initialize ports
rpc_port=$base_rpc_port
rpc_laddr_port=$base_rpc_laddr_port
p2p_port=$base_p2p_port
prometheus_port=$base_prometheus_port
api_port=$base_api_port
grpc_port=$base_grpc_port
grpc_web_port=$base_grpc_web_port
evm_rpc_port=$base_evm_rpc_port
evm_rpc_ws_port=$base_evm_rpc_ws_port

# Check if ports are in use and adjust if necessary for up to 10 possible projects
for i in {0..9}; do
  if is_port_in_use $rpc_port; then
    rpc_port=$((base_rpc_port + (i + 1) * 1000))
  fi

  if is_port_in_use $rpc_laddr_port; then
    rpc_laddr_port=$((base_rpc_laddr_port + (i + 1) * 1000))
  fi

  if is_port_in_use $p2p_port; then
    p2p_port=$((base_p2p_port + (i + 1) * 1000))
  fi

  if is_port_in_use $prometheus_port; then
    prometheus_port=$((base_prometheus_port + (i + 1) * 1000))
  fi

  if is_port_in_use $api_port; then
    api_port=$((base_api_port + (i + 1) * 100))
  fi

  if is_port_in_use $grpc_port; then
    grpc_port=$((base_grpc_port + (i + 1) * 100))
  fi

  if is_port_in_use $grpc_web_port; then
    grpc_web_port=$((base_grpc_web_port + (i + 1) * 100))
  fi

  if is_port_in_use $evm_rpc_port; then
    evm_rpc_port=$((base_evm_rpc_port + (i + 1) * 100))
  fi

  if is_port_in_use $evm_rpc_ws_port; then
    evm_rpc_ws_port=$((base_evm_rpc_ws_port + (i + 1) * 100))
  fi
done

# Check curl is installed
if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

# Update packages and install dependencies
printCyan "Updating packages..." && sleep 1
sudo apt update && sudo apt upgrade -y

printCyan "Installing dependencies..." && sleep 1
sudo apt-get update && sudo apt-get install -y git clang llvm ca-certificates curl build-essential binaryen protobuf-compiler libssl-dev pkg-config libclang-dev gcc unzip wget lz4 cmake jq

# Install Golang
printCyan "Installing golang..." && sleep 1
cd $HOME && \
ver="1.21.3" && \
wget "https://golang.org/dl/go$ver.linux-amd64.tar.gz" && \
sudo rm -rf /usr/local/go && \
sudo tar -C /usr/local -xzf "go$ver.linux-amd64.tar.gz" && \
rm "go$ver.linux-amd64.tar.gz" && \
echo "export PATH=$PATH:/usr/local/go/bin:$HOME/go/bin" >> ~/.bash_profile && \
source ~/.bash_profile && \
go version

# Clean up previous installations
printCyan "Deleting previous installation..." && sleep 1
sudo systemctl stop ogd
sudo systemctl stop 0gchaind
sudo systemctl disable 0gchaind.service
sudo systemctl disable ogd.service
sudo rm /etc/systemd/system/0gchaind.service
sudo rm /etc/systemd/system/ogd.service
sudo rm -r $HOME/.0gchain
sudo rm -r $HOME/.evmosd
sudo rm -rf $HOME/0g-evmos
sudo rm -rf $HOME/0g-chain
sudo rm -r $(which evmosd)
sudo rm -r $(which 0gchaind)

# Clone and build the software
printCyan "Cloning & building 0gchaind binary..." && sleep 1
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
cd 0g-chain/networks/testnet/
./install.sh
source $HOME/.bash_profile

# Initialize and configure the blockchain
printCyan "Initializing chain 0gchaind..." && sleep 1
cd $HOME
0gchaind init "$MONIKER" --chain-id "$CHAIN_ID_OG"
0gchaind config keyring-backend test

# Download genesis.json
printCyan "Downloading genesis.json..." && sleep 1
sudo apt install -y unzip wget
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json

# Backup and replace genesis.json
cd $HOME
sudo mv ~/.0gchain/config/genesis.json ~/.0gchain/config/genesis.json.backup
sudo mv ~/.0gchain/config/genesis.json.1 ~/.0gchain/config/genesis.json

# Add seeds and peers
printCyan "Adding seeds and peers..." && sleep 1
sed -i \
    -e 's/^seeds *=.*/seeds = "c4d619f6088cb0b24b4ab43a0510bf9251ab5d7f@54.241.167.190:26656"/' \
    -e 's/^persistent_peers *=.*/persistent_peers = "7379543f98e0015dcf53b3eaa596138fb9c75fca@83.246.253.4:26656,2dacc36d2458627d7b972e1cf76ce5c28550f322@185.252.232.16:26656,cfe299faebfa81a2a4191ff93c8f6136887238da@185.250.36.142:26656,fd5b7f303e24649dcfb7ea5251b3ba65189c6623@158.220.115.143:12656,b2f647c3704b04b03700b67fcca7477d3f3d4c9b@173.212.242.60:26656,adb020421007751d1fa3fe779796460e3889839e@161.97.94.69:12656,334a34478c82e8669aace6f1ee04b4c3e04a50bb@92.118.56.200:26656,3c820ec2075e297c013b2e2f083f6c15a4fad594@62.169.26.95:26656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,56715db4fbe48028778ebb7cfeeeb689d0d2fb9b@37.60.252.203:26656,8cecd90d6d0d2d64afea9735dbab5e6e21e7bf6f@195.179.229.40:26656,01f53ba9f8b1f1cbcd274c52751136a741633187@5.189.142.98:26656,8f1880f4140e3d8187d0d0ac003e10443f9216b0@89.117.55.63:26656,f397ebb8b1180d71c47e69fa685d1cf525769031@45.94.209.123:26656,ac25a6be1272692d3fc73dc84b749df870072370@5.189.146.123:26656"/' \
    ~/.0gchain/config/config.toml

# Configure pruning
printCyan "Configuring pruning..." && sleep 1
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.0gchain/config/app.toml

# Set minimum gas prices
printCyan "Setting min gas price..." && sleep 1
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00252aevmos\"/" $HOME/.0gchain/config/app.toml

# Enable the key-value indexer
printCyan "Enabling kv indexer..." && sleep 1
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.0gchain/config/config.toml

# Adjust ports in config files
adjust_ports $rpc_port $rpc_laddr_port $p2p_port $prometheus_port $api_port $grpc_port $grpc_web_port $evm_rpc_port $evm_rpc_ws_port

# Print new and previous port bindings
print_ports

# Add a new wallet
0gchaind keys add $WALLET_NAME --eth

# Create a service and run it
printCyan "Creating a service & running..." && sleep 1
sudo tee /etc/systemd/system/ogd.service > /dev/null <<EOF
[Unit]
Description=0gchaind Node Service
After=network.target

[Service]
User=$USER
ExecStart=$(which 0gchaind) start --home $HOME/.0gchain
Restart=on-failure
LimitNOFILE=4096

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ogd
sudo systemctl restart ogd

printLine

# Check the node status
printCyan "Checking 0g-Node status..." && sleep 1
if systemctl is-active --quiet ogd; then
  printf "Your ogd Node is installed and works!\n"
  printf "You can check ogd Node status by the command 'sudo systemctl status ogd'\n"
  printf "You can check ogd Logs by the command 'sudo journalctl -u ogd -f -o cat'\n"
else
  printf "Your ogd Node was not installed correctly, please reinstall by running: ./run.sh\n"
fi

# Print node information
printCyan "Check and save your node information:" && sleep 1
echo "MONIKER: $MONIKER"
echo "WALLET_NAME: $WALLET_NAME"
echo "IDENTITY: $IDENTITY"
echo "WEBSITE: $WEBSITE"
echo "EMAIL: $EMAIL"

# Instructions for next step
printCyan "What next?" && sleep 1
echo -e "\nCheck if your 0g-node is fully synced by running command: 0gchaind status | jq .sync_info.catching_up"
printCyan "must be = false" && sleep 1
echo -e "\nRequest tokens from faucet: https://faucet.0g.ai"
printCyan "Your address for Faucet is" && sleep 1
echo "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"
echo -e "\nCheck wallet balance after your 0g-node is fully synced and you have requested tokens from the faucet: 0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a)"
printCyan "Next - Create a validator and you are DONE!!!" && sleep 1

# Instructions for re-running the script
printf "\nTo re-run the script again, use: ./run.sh\e[0m\n"