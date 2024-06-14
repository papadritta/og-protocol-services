## How to Use:

#### 1. Download latest snapshot
```
wget https://snapshot-og.papadritta.com/latest_snapshot.tar.lz4
```
#### 2. Stop the node
```
sudo systemctl stop ogd
```
#### 3. Backup priv_validator_state.json
```
cp $HOME/.0gchain/data/priv_validator_state.json $HOME/.0gchain/priv_validator_state.json.backup
```
#### 4. Reset DB
```
sudo 0gchain tendermint unsafe-reset-all --home $HOME/.0gchain --keep-addr-book
```
#### 5. Extract files fromt the arvhive
```
lz4 -d -c ./latest_snapshot.tar.lz4 | tar -xf - -C $HOME/.0gchain
```
#### 6. Backup priv_validator_state.json
```
mv $HOME/.0gchain/priv_validator_state.json.backup $HOME/.0gchain/data/priv_validator_state.json
```
#### 7. Restart the node
```
sudo systemctl restart ogd && sudo journalctl -u ogd -f -o cat
```
#### 8. Check the synchronization status
```
0gchaind status | jq '.sync_info'
```
> check node status > false


