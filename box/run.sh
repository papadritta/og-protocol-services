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
printCyan "Cloning & build 0gchaind binary..." && sleep 1
git clone -b v0.1.0 https://github.com/0glabs/0g-chain.git
cd 0g-chain/networks/testnet/
./install.sh
source $HOME/.bash_profile

# Initialize and configure the blockchain
printCyan "Init chain 0gchaind..." && sleep 1
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
    -e 's/^persistent_peers *=.*/persistent_peers = "1b1d5996e51091b498e635d4ee772d3951e54d47@62.171.142.222:12656,3b0fd60499e74b773b85f4741d6b934f5e226912@158.220.109.208:12656,3cbb3424411d1131a40dd867ef01fd3fc505bed0@77.237.238.41:33556,adb020421007751d1fa3fe779796460e3889839e@161.97.94.69:12656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,8956c62a1e02a7798da2007c408fe011fbb6ab28@65.21.69.53:14256,a7cd7ef5b92e1b649dd4105d373dae3d563cfbd2@188.40.127.95:26656,caf554a43fec67ad4e22ede2924c8ebff4eefbbd@4.213.58.235:13456,4a0010b186d3abc0aad75bb2e1f6743d6684b996@116.202.196.217:12656,52b1994a0684ec18302039ee1d3b7b4b4583da4c@84.247.128.194:12656,aa136118f8958b14abf1428ef0f376db97165f40@77.237.240.21:26656,3734b9356dadb67f880dd6c2b3c54a76ec5eb182@37.60.224.149:26656,2b5e2dcb5a307529f064b08137e70295785df547@38.242.210.236:26656,d7fa28ebd8d704931810feca143961da973e12b8@37.61.220.75:12656,916f2d67af81003d419924b4979890561321b347@167.235.72.90:12656"/' \
    ~/.0gchain/config/config.toml

# Configure prunning
printCyan "Configure prunning..." && sleep 1
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.0gchain/config/app.toml

# Set minimum gas prices
printCyan "Set min gas price..." && sleep 1
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0.00252aevmos\"/" $HOME/.0gchain/config/app.toml

# Enable the key-value indexer
printCyan "Enable kv indexer..." && sleep 1
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.0gchain/config/config.toml

# Create a service and run it
printCyan "Create a service & run..." && sleep 1
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
printCyan "Check 0g-Node status..." && sleep 1
if systemctl is-active --quiet ogd; then
  printf "Your ogd Node is installed and works!\n"
  printf "You can check ogd Node status by the command 'sudo systemctl status ogd'\n"
  printf "You can check ogd Logs by the command 'sudo journalctl -u ogd -f -o cat'\n"
else
  printf "Your ogd Node was not installed correctly, please reinstall.\n"
fi