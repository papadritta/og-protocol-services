1. System updates, installation of required environments
```
sudo apt-get update
sudo apt-get install clang cmake build-essential
```
2. Install Go (If it is the same node as the validator node, you can PASS)
```
wget https://go.dev/dl/go1.22.0.linux-amd64.tar.gz
sudo rm -rf /usr/local/go && sudo tar -C /usr/local -xzf go1.22.0.linux-amd64.tar.gz
export PATH=$PATH:/usr/local/go/bin
```
3. Install Rustup (When the selection for 1, 2, or 3 appears, just press Enter.)
```
curl --proto '=https' --tlsv1.2 -sSf https://sh.rustup.rs | sh
```
4. Clone the 0G Storage Node repository
```
git clone -b v0.2.0 https://github.com/0glabs/0g-storage-node.git
```
5. Build the project
```
cd $HOME/0g-storage-node
git submodule update --init
sudo apt install cargo
cargo build --release
```
6. Set up environment variables
```
echo 'export ZGS_CONFIG_FILE="$HOME/0g-storage-node/run/config.toml"' >> ~/.bash_profile
echo 'export ZGS_LOG_DIR="$HOME/0g-storage-node/run/log"' >> ~/.bash_profile
echo 'export ZGS_LOG_CONFIG_FILE="$HOME/0g-storage-node/run/log_config"' >> ~/.bash_profile
echo 'export LOG_CONTRACT_ADDRESS="0x2b8bC93071A6f8740867A7544Ad6653AdEB7D919"' >> ~/.bash_profile
echo 'export MINE_CONTRACT="0x228aCfB30B839b269557214216eA4162db24445d"' >> ~/.bash_profile
echo 'export WALLET_STORAGE="storage"' >> ~/.bash_profile
source ~/.bash_profile
```
7. Chose one of the option 7.1 or 7.2:

- 7.1 Extract and store private key (if you run STORAGE on the same server with Validator node)
```
0gchaind keys unsafe-export-eth-key $WALLET_STORAGE
```
Type and store your private key:
```
read -sp "Enter your private key: " PRIVATE_KEY && echo
sed -i 's|miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml
```
- 7.2 Extract and store private key (if your run STORAGE on different server Non-validator node)

>Open MetaMask and add a network - Click the Add network directly button and use the following details:
```
Network name : 0g Chain Testnet
New RPC URL : https://rpc-testnet.0g.ai
Chain ID : 16600
Currency symbol: A0GI
Block explorer URL (Optional) : https://scan-testnet.0g.ai/
```
>Extract your private key from MM.

Type and store your private key:
```
read -sp "Enter your private key: " PRIVATE_KEY && echo
sed -i 's|miner_key = ""|miner_key = "'"$PRIVATE_KEY"'"|' $HOME/0g-storage-node/run/config.toml
```
8. Update your config.toml
```
sed -i 's|# log_config_file = "log_config"|log_config_file = "'"$ZGS_LOG_CONFIG_FILE"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# log_directory = "log"|log_directory = "'"$ZGS_LOG_DIR"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|mine_contract_address = ".*"|mine_contract_address = "'"$MINE_CONTRACT"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|log_contract_address = ".*"|log_contract_address = "'"$LOG_CONTRACT_ADDRESS"'"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|blockchain_rpc_endpoint = "https://rpc-testnet.0g.ai"|blockchain_rpc_endpoint = "https://0g-evm.rpc.nodebrand.xyz"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_dir = "network"|network_dir = "network"|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# network_libp2p_port = 1234|network_libp2p_port = 1234|' $HOME/0g-storage-node/run/config.toml
sed -i 's|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmPxGNWu9eVAQPJww79J32pTJLKGcpjRMb4Qb8xxKkyuG1","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAm93Hd5azfhkGBbkx1zero3nYHvfjQYM2NtiW4R3r5bE2g"\]|network_boot_nodes = \["/ip4/54.219.26.22/udp/1234/p2p/16Uiu2HAmTVDGNhkHD98zDnJxQWu3i1FL1aFYeh9wiQTNu4pDCgps","/ip4/52.52.127.117/udp/1234/p2p/16Uiu2HAkzRjxK2gorngB1Xq84qDrT4hSVznYDHj6BkbaE4SGx9oS"\]|' $HOME/0g-storage-node/run/config.toml
sed -i 's|# db_dir = "db"|db_dir = "db"|' $HOME/0g-storage-node/run/config.toml
Additional blockchain_rpc_endpoint setting (if not already updated):
```
```
sed -i 's|blockchain_rpc_endpoint = ".*"|blockchain_rpc_endpoint = "https://rpc-og.papadritta.com"|' $HOME/0g-storage-node/run/config.toml
```
9. Create Service File
```
sudo tee /etc/systemd/system/zgs.service > /dev/null <<EOF
[Unit]
Description=ZGS Node
After=network.target

[Service]
User=ubuntu
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
```
10. Service execution
```
sudo systemctl daemon-reload
sudo systemctl enable zgs
sudo systemctl start zgs
sudo systemctl status zgs
```
11. Check your latest log
```
LATEST_LOG=$(ls -Art ~/0g-storage-node/run/log/ | tail -n 1)
cat ~/0g-storage-node/run/log/$LATEST_LOG | tail -n 100 | tac
```
