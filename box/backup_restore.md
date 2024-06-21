## Backup & Restore all Node info exept data dir (the priv_validator_state.json is also stored in backup dir)
- For `BACKUP NODE OG` you can use a Script (Use it before Hardfork)
Copy & Paste and script proceed automaticly
```
wget -O backup_0gchain.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/scripts/backup_0gchain.sh && chmod +x backup_0gchain.sh && ./backup_0gchain.sh
```
- it will save the following node info under `$HOME/0gchain_backup` dir
```
.0gchain/
├── **********************************123456.address
├── config
│   ├── addrbook.json
│   ├── app.toml
│   ├── client.toml
│   ├── config.toml
│   ├── config.toml.bak
│   ├── genesis.json
│   ├── genesis.json.backup
│   ├── node_key.json
│   ├── priv_validator_key.json
│   ├── write-file-atomic-*
├── keyhash
├── wallet.info
└── data
    └── priv_validator_state.json
```
