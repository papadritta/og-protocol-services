#!/bin/bash

exists() {
  command -v "$1" >/dev/null 2>&1
}

is_port_in_use() {
  ss -tulpen | awk '{print $5}' | grep -q ":$1$"
}

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

set_env_var() {
  local var_name="$1"
  local var_value="$2"
  if grep -q "export $var_name=" ~/.bash_profile; then
    sed -i.bak "/export $var_name=/c\export $var_name=\"$var_value\"" ~/.bash_profile
  else
    echo "export $var_name=\"$var_value\"" >> ~/.bash_profile
  fi
}

base_rpc_port=26656
base_rpc_laddr_port=26657
base_p2p_port=26658
base_prometheus_port=6060
base_api_port=1317
base_grpc_port=9090
base_grpc_web_port=9091
base_evm_rpc_port=8545
base_evm_rpc_ws_port=8546

CHAIN_ID_OG="zgtendermint_16600-2"
DETAILS="OG to the >>> Moon"

bash_profile="$HOME/.bash_profile"
if [ -f "$bash_profile" ]; then
    . "$bash_profile"
fi

source <(curl -s https://raw.githubusercontent.com/papadritta/scripts/main/main.sh)

printLogo

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

read -p "Enter Identity (IDENTITY, press ENTER to skip): " IDENTITY
read -p "Enter Website (WEBSITE, press ENTER to skip): " WEBSITE
read -p "Enter Email (EMAIL, press ENTER to skip): " EMAIL

set_env_var "MONIKER" "$MONIKER"
set_env_var "WALLET_NAME" "$WALLET_NAME"
set_env_var "CHAIN_ID_OG" "$CHAIN_ID_OG"
set_env_var "DETAILS" "$DETAILS"

set_env_var "IDENTITY" "$IDENTITY"
set_env_var "WEBSITE" "$WEBSITE"
set_env_var "EMAIL" "$EMAIL"

source ~/.bash_profile

rpc_port=$base_rpc_port
rpc_laddr_port=$base_rpc_laddr_port
p2p_port=$base_p2p_port
prometheus_port=$base_prometheus_port
api_port=$base_api_port
grpc_port=$base_grpc_port
grpc_web_port=$base_grpc_web_port
evm_rpc_port=$base_evm_rpc_port
evm_rpc_ws_port=$base_evm_rpc_ws_port

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

if ! exists curl; then
  sudo apt update && sudo apt install curl -y < "/dev/null"
fi

printCyan "Updating packages..." && sleep 1
sudo apt update && sudo apt upgrade -y

printCyan "Installing dependencies..." && sleep 1
sudo apt-get update && sudo apt-get install -y git clang llvm ca-certificates curl build-essential binaryen protobuf-compiler libssl-dev pkg-config libclang-dev gcc unzip wget lz4 cmake jq

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

printCyan "Cloning & building 0gchaind binary..." && sleep 1
cd $HOME
git clone -b v0.2.3 https://github.com/0glabs/0g-chain
cd 0g-chain
git checkout tags/v0.2.3
make install
source $HOME/.bash_profile

printCyan "Initializing chain 0gchaind..." && sleep 1
cd $HOME
0gchaind init "$MONIKER" --chain-id "$CHAIN_ID_OG"
0gchaind config keyring-backend test

printCyan "Downloading genesis.json..." && sleep 1
rm $HOME/.0gchain/config/addrbook.json $HOME/.0gchain/config/genesis.json
sudo apt install -y unzip wget
wget -P ~/.0gchain/config https://github.com/0glabs/0g-chain/releases/download/v0.2.3/genesis.json
0gchaind validate-genesis

printCyan "Adding seeds and peers..." && sleep 1
sed -i \
    -e 's/^seeds *=.*/seeds = "59df4b3832446cd0f9c369da01f2aa5fe9647248@162.55.65.137:27956"/' \
    -e 's/^persistent_peers *=.*/persistent_peers = "5a9aac3b111f8ef78da298d747f6f79daf2b5954@31.220.75.10:12656,df4cc52fa0fcdd5db541a28e4b5a9c6ce1076ade@37.60.246.110:13456,4151763741fb533d56f51bbf56be514a2a6764f7@173.249.60.23:12656,6e044d233c4abb2cc970c8fc2e968273c38a874e@167.86.116.237:12656,5344c27c5c70ce0e821348900e365b01801f0a41@38.242.242.153:12656,5e6c41eaefd9857989b5216ae9910503483f5357@116.202.49.230:26656,d7921529d985b18096ea5cc5d023806af91fd51e@157.90.128.250:58656,d7535cad33e0c7cfc7274807862eebff32b81906@45.136.17.23:26656,55982724a7a30944215ad45924071f1efc1eef4a@116.202.174.53:26856,87050b88e0dff2df18caff484e01c32d9f6e6a49@185.209.223.108:12656,5ba403bf2183ffbc2aea2508af82041ad69cb883@195.201.242.245:12656,6a07fd41680eacfd29b63c7ce07a0f20af18bfa8@193.233.75.244:26656,3b3ddcd4de429456177b29e5ca0febe4f4c21989@75.119.139.198:26656,7e6124b7816c2fddd1e0f08bbaf0b6876230c5f4@37.27.120.13:26656,806f194271899ed818e05d63921f9032bcf96553@158.220.83.6:26656"/' \
    ~/.0gchain/config/config.toml

printCyan "Configuring pruning..." && sleep 1
sed -i.bak -e "s/^pruning *=.*/pruning = \"custom\"/" -e "s/^pruning-keep-recent *=.*/pruning-keep-recent = \"100\"/" -e "s/^pruning-interval *=.*/pruning-interval = \"10\"/" $HOME/.0gchain/config/app.toml

printCyan "Setting min gas price..." && sleep 1
sed -i "s/^minimum-gas-prices *=.*/minimum-gas-prices = \"0ua0gi\"/" $HOME/.0gchain/config/app.toml

printCyan "Enabling kv indexer..." && sleep 1
sed -i "s/^indexer *=.*/indexer = \"kv\"/" $HOME/.0gchain/config/config.toml

printCyan "Setting json-rpc..." && sleep 1
sed -i -e 's/address = "127.0.0.1:8545"/address = "0.0.0.0:8545"/' -e 's|^api = ".*"|api = "eth,txpool,personal,net,debug,web3"|' $HOME/.0gchain/config/app.toml

adjust_ports $rpc_port $rpc_laddr_port $p2p_port $prometheus_port $api_port $grpc_port $grpc_web_port $evm_rpc_port $evm_rpc_ws_port

print_ports

0gchaind keys add $WALLET_NAME --eth

printCyan "Creating a service & running..." && sleep 1
sudo tee /etc/systemd/system/ogd.service > /dev/null <<EOF
[Unit]
Description=OG Node
After=network.target

[Service]
User=$USER
Type=simple
ExecStart=/root/go/bin/0gchaind start --json-rpc.api eth,txpool,personal,net,debug,web3 --home /root/.0gchain
Environment="G0GC=900"
Environment="G0MELIMIT=40GB"
Restart=on-failure
LimitNOFILE=65535

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable ogd
sudo systemctl restart ogd

printLine

printCyan "Checking 0g-Node status..." && sleep 1
if systemctl is-active --quiet ogd; then
  printf "Your ogd Node is installed and works!\n"
  printf "You can check ogd Node status by the command 'sudo systemctl status ogd'\n"
  printf "You can check ogd Logs by the command 'sudo journalctl -u ogd -f -o cat'\n"
else
  printf "Your ogd Node was not installed correctly, please reinstall by running: ./run.sh\n"
fi

printCyan "Check and save your node information:" && sleep 1
echo "MONIKER: $MONIKER"
echo "WALLET_NAME: $WALLET_NAME"
echo "IDENTITY: $IDENTITY"
echo "WEBSITE: $WEBSITE"
echo "EMAIL: $EMAIL"

printCyan "What next?" && sleep 1
echo -e "\nCheck if your 0g-node is fully synced by running command: 0gchaind status | jq .sync_info.catching_up"
printCyan "must be = false" && sleep 1
echo -e "\nRequest tokens from faucet: https://faucet.0g.ai"
printCyan "Your address for Faucet is" && sleep 1
echo "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"
echo -e "\nCheck wallet balance after your 0g-node is fully synced and you have requested tokens from the faucet: 0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a)"
printCyan "Next - Create a validator and you are DONE!!!" && sleep 1

printf "\nTo re-run the script again, use: ./run.sh\e[0m\n"