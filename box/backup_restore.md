## Backup & Restore all Node info exept data dir (the priv_validator_state.json is also stored in backup dir)
- For `BACKUP NODE OG` you can use a Script (Use it before Hardfork)
Copy & Paste and script proceed automaticly
```
wget -O backup_0gchain.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/scripts/backup_0gchain.sh && chmod +x backup_0gchain.sh && ./backup_0gchain.sh
```

- For `RESTORE NODE OG` you can use a Script (Use it after Hardfork or if you want to move and restore on another server)
```
wget -O restore_0gchain.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/scripts/restore_0gchain.sh && chmod +x restore_0gchain.sh && ./restore_0gchain.sh
```

