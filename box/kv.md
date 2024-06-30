## 🚀 Quick KV STORAGE NODE OG Installation Script:
```bash
Chain ID: zgtendermint_16600-2
Version of binary: v1.1.0-testnet
Name of binary: zgs_kv
Systemd service: zgs-kv.service
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
wget -O storage-kv.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/scripts/storage-kv.sh && chmod +x storage-kv.sh && ./storage-kv.sh
```
>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

- **Check the logs**
```bash
sudo journalctl -u zgs-kv -f -o cat
```
ALL DONE !!!

### [What next? >>>](/box/da.md)