![1](https://github.com/papadritta/og-protocol-services/assets/90826754/44003484-ed9a-4e48-a598-bfe258366c35)
## 🚀 Quick NODE OG Installation Script:
```bash
Chain ID: zgtendermint_16600-2
Version of binary: v0.2.3
Name of binary: 0gchaind
Systemd service: ogd.service
```
#### 🛠️ Features:
- **Automated Setup**: No prior knowledge needed.
- **Ports Conflict Resolution**: Automatically resolves port issues.
- **Environment Variables**: Manages all necessary variables.
- **Full Installation**: Installs dependencies, configures settings, and starts your node.

#### 🌟 Benefits:
- **User-Friendly**: No technical expertise required.
- **Time-Saving**: Automates the entire setup.
- **Comprehensive**: From installation to initialization.

#### 📝 How to Use:
1. **Copy & paste**: The script will run automatically.
2. **Follow Prompts**: Enter required info as prompted.

```bash
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/scripts/run.sh && chmod +x run.sh && ./run.sh
```
>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

### What next? >>>

- **Check the node is fully synced**: must be > falce
```bash
0gchaind status | jq .sync_info.catching_up
```
>if the status still 'true' > just wait for fully sync > or download the Snapshot 

- **Fresh Snapshot**: [Update every 3 hours](box/Snapshot.md)

- **Request tokens from faucet** [Faucet](https://faucet.0g.ai)
>Your address copy from installation script output or, if you fogot, do it again by running command:
```bash
echo "ADDRESS_FOR_FAUCET: "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"
```
- **Check wallet balance**
```bash
0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a) 
```

- **Set your vars**:

```bash
# Set up the variables & Change to your parametrs:

#### your_Node_name
#### your_Wallet_name
#### your_Keybase_ID
#### your_website
#### your_email
#### your_any_ideas (for Example: OG to the Moon)

echo 'export MONIKER="your_Node_name"' >> ~/.bash_profile
echo 'export WALLET_NAME="your_Wallet_name"' >> ~/.bash_profile
echo 'export CHAIN_ID_OG="zgtendermint_16600-1"' >> ~/.bash_profile
echo 'export IDENTITY="your_Keybase_ID"' >> ~/.bash_profile
echo 'export WEBSITE="your_website"' >> ~/.bash_profile
echo 'export EMAIL="your_email"' >> ~/.bash_profile
echo 'export DETAILS="your_any_ideas"' >> ~/.bash_profile
echo 'export RPC_PORT="26657"' >> ~/.bash_profile
source $HOME/.bash_profile
```
- **Create a Validator**: Just copy and paste 
```bash
0gchaind tx staking create-validator \
  --amount=1000000ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=$CHAIN_ID_OG \
  --commission-rate=0.10 \
  --commission-max-rate=0.20 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1 \
  --from=$WALLET_NAME \
  --identity=$IDENTITY \
  --website=$WEBSITE \
  --security-contact=$EMAIL \
  --details=$DETAILS \
  --gas=auto --gas-adjustment=1.4 \
  -y
```
- **Delegate Tokens to your Validator (Selfbond)**: Amount `900000ua0gi` adjust to your wallet ballance
```bash
0gchaind tx staking delegate $(0gchaind keys show $WALLET_NAME --bech val -a) 900000ua0gi --from $WALLET_NAME --gas=auto --gas-adjustment=1.1 -y
```

ALL DONE !!!

### [What next? >>>](/box/storage.md)