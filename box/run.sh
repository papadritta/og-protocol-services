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
    -e 's/^persistent_peers *=.*/persistent_peers = "7379543f98e0015dcf53b3eaa596138fb9c75fca@83.246.253.4:26656,bffc12a9724ac3f045fcc6f77484b57f040aa924@194.163.160.70:26656,2dacc36d2458627d7b972e1cf76ce5c28550f322@185.252.232.16:26656,fd5b7f303e24649dcfb7ea5251b3ba65189c6623@158.220.115.143:12656,00e4f43c6822d503092ffefff4d13db26b2877a2@38.242.158.147:26656,adb020421007751d1fa3fe779796460e3889839e@161.97.94.69:12656,334a34478c82e8669aace6f1ee04b4c3e04a50bb@92.118.56.200:26656,3c820ec2075e297c013b2e2f083f6c15a4fad594@62.169.26.95:26656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,01f53ba9f8b1f1cbcd274c52751136a741633187@5.189.142.98:26656,f397ebb8b1180d71c47e69fa685d1cf525769031@45.94.209.123:26656,ac25a6be1272692d3fc73dc84b749df870072370@5.189.146.123:26656,6266b11372e58e8360f34c90bc8f36f50487c295@77.237.236.105:26656,b573194a6183cf51fb5b4614ee6ea423102d60aa@94.130.143.97:36656,62f2d13d13999f7bf342d1329ad935490d3958df@202.61.254.126:13456"/' \
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