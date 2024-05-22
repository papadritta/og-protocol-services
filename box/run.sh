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
    -e 's/^persistent_peers *=.*/persistent_peers = "57c1b2d83f6eeb5cca55225cbdb57aa8c72cd854@135.181.5.169:45656,9e2febd1c051e695e99d0180141f13eb7da128a6@75.119.152.232:26656,1d138c148692ab5830fc99979f6d376e25994a50@213.199.41.243:26656,e776d3cd2e2c1223f3ad00af2fa7f85173609019@185.103.100.198:26656,ebaccf331df166fe6f5579d190d08776f8c5004d@45.67.212.83:26656,d2cd9e5b011e2321ebb58bdd7a49b660b82e67b0@80.71.227.77:26656,09276ca89027a4357ea7e68d0bfc25e58fe77377@176.126.87.189:26656,9087a83002cbacaaa1cc7532c086410fa89d3a70@88.198.52.89:64656,e2f0de202df1770b8e7e2780e1562e138caaf8a6@62.169.18.171:26656,3492fde06a28171cb8e257a5a00448ae10ef9d68@194.163.157.109:12656,fde6660ee4551f36ffefe549fefb4aa093ac7f29@194.35.120.148:12656,2b5e2dcb5a307529f064b08137e70295785df547@38.242.210.236:26656,773a0b5f35225210c0f04d78bf28bed2836c13c5@38.242.156.74:26656,c024d83af04b34f9afef7d6f8b00343978174a1c@37.27.117.171:26656,5d2074e5a5631c4b95b06a1469439e6a2dad0961@212.192.26.234:26656"/' \
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