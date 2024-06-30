![335649682-2afad023-c7f6-49c1-a2d0-fde81d6133b0](https://github.com/papadritta/og-protocol-services/assets/90826754/2149ee59-7b31-4896-adb1-175013b0b4a1)
## 🚀 Quick STORAGE NODE OG Installation Script:
```bash
Chain ID: zgtendermint_16600-2
Version of binary: v0.3.2
Name of binary: zgs_node
Systemd service: zgs.service
```
#### 🛠️ Features:
- **Automated Setup**: No prior knowledge needed.
- **Environment Variables**: Manages all necessary variables.
- **Full Installation**: Installs dependencies, configures settings, and starts your storage node.

#### 🌟 Benefits:
- **User-Friendly**: No technical expertise required.
- **Time-Saving**: Automates the entire setup.
- **Comprehensive**: From installation to initialization.

#### 📝 How to Use:
1. **Copy & paste**: The script will run automatically.
2. **Follow Prompts**: Enter required info as prompted.

```bash
wget -O storage.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/scripts/storage.sh && chmod +x storage.sh && ./storage.sh
```
>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)
>In this script I used my RPC https://rpc-og.papadritta.com and you can keep it by default, but you can add yours, or use https://rpc-storage-testnet.0g.ai

- **Request tokens from faucet** [Faucet](https://faucet.0g.ai)
>Your address copy from installation script output or, if you fogot, do it again by running command:
```bash
ADDRESS=$(0gchaind keys show $WALLET_STORAGE -a --keyring-backend=test) && HEX_ADDRESS=$(0gchaind debug addr $ADDRESS | awk '/hex/ {print $3}') && [ -n "$HEX_ADDRESS" ] && echo "ADDRESS_FOR_FAUCET: 0x$HEX_ADDRESS"
```
- **Restart your zgs service and Check the logs**
```bash
sudo systemctl restart zgs
```
```bash
tail -f ~/0g-storage-node/run/log/zgs.log.$(TZ=UTC date +%Y-%m-%d)
```
ALL DONE !!!

### [What next? >>>](/box/kv.md)