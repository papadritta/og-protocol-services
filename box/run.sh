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
    -e 's/^persistent_peers *=.*/persistent_peers = "23116671a45dddfe581a1dd14c6d94170d44840a@176.9.39.118:26656,b0ec2c2e7cbc262308faaf678230bf354c3344f2@213.202.255.68:16656,577d86a40030c5d649b40c463a0367120d74b621@176.36.75.115:26656,3430ca86b2d781618dcc6132ca3e3419ea69568a@161.97.93.174:26656,ebaccf331df166fe6f5579d190d08776f8c5004d@45.67.212.83:26656,4703a6eaff8accb63fedc7b54313a460e1cabbf4@84.247.137.38:26656,04832883d0ae95974046494f559f4d7428c35cbd@185.40.79.58:26656,d8f3c4245005f77c0cb869b24cd733d9599a4a52@95.217.63.53:26656,344ba4690fe303aadc828d31328d0a8b3a127c98@207.180.236.138:16656,9a4581f34e1af328872ec71162a7ae76975f637f@156.67.29.89:26656,4d950bcd8e1885fae83c3003b23b91c2c43d888c@165.22.99.201:16656,2735dea46c2d8e814246c64f0b0d716ac966770f@166.1.70.240:26656,29faf995bdd64fccc0766ccd173797537e9587d7@31.220.100.221:26656,90fb16e5360d64ac2332009cfc7b2eb6e8df64e7@212.162.153.183:26656,66a25d8c4b6de583762d02def6e4d0f913f66ffa@15.235.144.20:47656"/' \
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