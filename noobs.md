![1](https://github.com/papadritta/og-protocol-services/assets/90826754/44003484-ed9a-4e48-a598-bfe258366c35)
## 🚀 Quick NODE OG Installation Script

#### 🛠️ Features:
- **Automated Setup**: No prior knowledge needed.
- **Ports Conflict Resolution**: Automatically resolves port issues.
- **Environment Variables**: Manages all necessary variables.
- **Full Installation**: Installs dependencies, configures settings, and starts your node.

#### 📝 How to Use:
1. **Copy & paste**: The script will run automatically.
2. **Follow Prompts**: Enter required info as prompted.

#### 🌟 Benefits:
- **User-Friendly**: No technical expertise required.
- **Time-Saving**: Automates the entire setup.
- **Comprehensive**: From installation to initialization.
```
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/box/run.sh && chmod +x run.sh && ./run.sh
```
>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

### What next? >>>

- **Check the node is fully synced**: must be > falce
```
0gchaind status | jq .sync_info.catching_up
```
>if the status still 'true' > just wait for fully sync

- **Request tokens from faucet** [Faucet](https://faucet.0g.ai)
>Your address copy from installation script output or, if you fogot, do it again by running command:
```
echo "0x$(0gchaind debug addr $(0gchaind keys show $WALLET_NAME -a) | grep hex | awk '{print $3}')"
```
- **Check wallet balance**
```
0gchaind q bank balances $(0gchaind keys show $WALLET_NAME -a) 
```
- **Create a Validator**: Just copy and paste 
```
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
```
0gchaind tx staking delegate $(0gchaind keys show $WALLET_NAME --bech val -a) 900000ua0gi --from $WALLET_NAME --gas=auto --gas-adjustment=1.1 -y
```

ALL DONE !!!

### What next? >>>

### 🚀 Quick STORAGE NODE OG Installation Script

