#!/bin/bash

# Function to check if a command exists
exists() {
  command -v "$1" >/dev/null 2>&1
}

# Ensure curl is installed
if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

# Source the bash_profile if it exists
bash_profile="$HOME/.bash_profile"
if [ -f "$bash_profile" ]; then
    . "$bash_profile"
fi

# Execute script from a verified source
source <(curl -s https://raw.githubusercontent.com/papadritta/scripts/main/main.sh)

printLogo

read -p "Enter Validator name: " MONIKER
printLine
printf "Node name: ${CYAN}%s${NC}\n" "$MONIKER"
printLine
sleep 2

read -p "Enter Wallet name: " WALLET_NAME
printLine
printf "Node name: ${CYAN}%s${NC}\n" "$WALLET_NAME"
printLine
sleep 2

# Set and export chain ID
echo 'export CHAIN_ID_OG="zgtendermint_16600-1"' >> ~/.bash_profile
source ~/.bash_profile

# Update packages and install dependencies
printCyan "Updating packages..." && sleep 1
sudo apt update && sudo apt upgrade -y

printCyan "Installing dependencies..." && sleep 1
sudo apt-get update && sudo apt-get install -y git clang llvm ca-certificates curl build-essential binaryen protobuf-compiler libssl-dev pkg-config libclang-dev gcc unzip wget lz4 cmake jq

# Install Golang
printCyan "Installation golang..." && sleep 1
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
sudo systemctl disable ogd.service
sudo rm /etc/systemd/system/ogd.service
sudo rm -rf $HOME/0g-evmos
sudo rm -rf $HOME/0g-chain
sudo rm -r $(which evmosd)
sudo rm -r $(which 0gchaind)

# Clone and build the software
printCyan "Cloning & build evmosd binary..." && sleep 1
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
cd 0g-chain/networks/testnet/
./install.sh
source $HOME/.bash_profile

# Initialize and configure the blockchain
printCyan "Init chain evmosd..." && sleep 1
cd $HOME
0gchaind init "$MONIKER" --chain-id "$CHAIN_ID_OG"
0gchaind config chain-id "$CHAIN_ID_OG"

# Download genesis.json
printCyan "Download genesis.json..." && sleep 1
sudo apt install -y unzip wget
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.1.0/genesis.json

# Backup and replace genesis.json
cd $HOME
sudo mv $HOME/.0gchain/config/genesis.json $HOME/.0gchain/config/genesis.json.backup
sudo mv $HOME/.0gchain/config/genesis.json.1 $HOME/.0gchain/config/genesis.json

# Add seeds and peers
printCyan "Add seeds and peers..." && sleep 1
sed -i \
    -e 's/^seeds *=.*/seeds = "c4d619f6088cb0b24b4ab43a0510bf9251ab5d7f@54.241.167.190:26656"/' \
    -e 's/^persistent_peers *=.*/persistent_peers = "7d5b39d7b4c7e8922812e327aba6266fd8db1fbd@62.169.27.167:26656,0a0b54852a271923277b03366a1f0a1dacbcd464@109.199.102.47:26656,d50aa74398af77c6c7bb5483bb1760989b780b8d@109.123.236.150:26656,377730397250ae2d016b4b7853a516920627deb7@81.17.96.227:26656,213a99e681bcd8160ea1d209b8298c86e0355e67@94.156.117.229:26656,4b37705126b4cf304265e9d31c982b39bfb76c9a@94.156.117.19:26656,6220bc5afb26f02627d13819b282aadad14f07c1@38.242.201.36:26656,ffa48d99f37eaf5473a02487ef26fd7691f770aa@149.102.141.113:26656,74fd185131f9903c694dec71a17b5def4f5d6fc1@80.71.227.186:26656,149f92d947d99aaadf2f1a01f510d528915b1952@45.94.209.90:26656,3bc22d3f241e2a292b583f06bc875f272ec2873e@207.244.244.26:26656,da69988481b49b9e6865620a1296366bf36aeb11@213.199.39.178:26656,eb5053d264804ec65922065f888393ed38f6264c@5.78.79.198:16656,491ad613f55d25b13b8b4e5d1e028ebbe74f07ce@156.67.29.95:26656,d868b20387f7f76c5ab346aee1f92dd2cf7e309f@46.4.80.48:28056"/' \
    ~/.0gchain/config/config.toml

# Configure prunning
printCyan "Configure prunning..." && sleep 1
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.evmosd/config/app.toml

# Set minimum gas prices
printCyan "Set min gas price..." && sleep 1
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00252aevmos\"/" $HOME/.evmosd/config/app.toml

# Enable the key-value indexer
printCyan "Enable kv indexer..." && sleep 1
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.evmosd/config/config.toml

# Create a service and run it
printCyan "Create a service & run..." && sleep 1
sudo tee /etc/systemd/system/ogd.service > /dev/null <<EOF
[Unit]
Description=0gchaind Node Service
After=network.target

[Service]
User=$USER
ExecStart=$(which 0gchaind) start --home $HOME/.evmosd
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
printCyan "Check 0g-Node status..." && sleep 1
if systemctl is-active --quiet ogd; then
  printf "Your ogd Node is installed and works!\n"
  printf "You can check ogd Node status by the command 'sudo systemctl status ogd'\n"
  printf "You can check ogd Logs by the command 'sudo journalctl -u ogd -f -o cat'\n"
else
  printf "Your ogd Node was not installed correctly, please reinstall.\n"
fi