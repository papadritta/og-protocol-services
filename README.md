<p align="center">
  <img src="https://github.com/papadritta/og-protocol-services/assets/90826754/5ec4b835-bb11-44d2-85d6-a644b6e6916e" width="400" alt="OG Logo">
</p>

# OG protocol 'Testnet Newton' services
Repo with public services for OG: kv, RPC, storage-node, peers, snapshots etc

#### 0G Testnet Newton
```
Chain Id: zgtendermint_16600-2
```
#### Official links:
- 0G Testnet Newton Onboarding: [https://tinyurl.com/4eyjk5fe](https://tinyurl.com/4eyjk5fe)
- 0G gitbook/docs: [https://zerogravity.gitbook.io/0g-doc](https://zerogravity.gitbook.io/0g-doc/)
- OG Github repo: [https://github.com/0glabs](https://github.com/0glabs)
- 0G Youtube Channel: [https://www.youtube.com/@0G_Labs](https://www.youtube.com/@0G_Labs)
- 0G Faucet Link: [https://faucet.0g.ai](https://faucet.0g.ai/)
- 0G Scan: [https://scan-testnet.0g.ai](https://scan-testnet.0g.ai/)
- 0G Newton explorer: [https://chainscan-newton.0g.ai/](https://chainscan-newton.0g.ai/)
- OG StorageScan: [https://storagescan-newton.0g.ai/](https://storagescan-newton.0g.ai/)

## Configuration Parameters
This section details the specific configuration parameters set for the OG Services.

| Parameter          | Value                                    |
| ------------------ | ---------------------------------------- |
| `indexing`         | kv                                       |
| `pruning`          | custom (100/10)                          |
| `min-retain-blocks`| 0                                        |
| `snapshot-interval`| 1200                                     |
| `snapshot-keep-recent` | 2                                    |
| `minimum-gas-prices`  | 0.00252ua0gi                          |

![3](https://github.com/papadritta/og-protocol-services/assets/90826754/5b4b6b87-5fd4-4e71-a0fe-c702f6b333b3)
# Services:
## Guides & Snapshots
- **Script for quick NODE OG**: [Installation](box/starter.md)
- **Script for quick STORAGE NODE OG**: [Installation](box/starter.md)
- **Fresh Snapshot**: [Update every 3 hours](box/Snapshot.md)

## Access Points
Services provide various endpoints for access and interaction through different protocols:

- **RPC**: [https://rpc1-og.papadritta.com](https://rpc1-og.papadritta.com)
- **RPC**: [https://rpc2-og.papadritta.com](https://rpc2-og.papadritta.com)

- **RPC(JSON)**: [https://rpc-og.papadritta.com](https://rpc-og.papadritta.com)
- **API**: [https://api-og.papadritta.com](https://api-og.papadritta.com)
- **gRPC**: [https://grpc-og.papadritta.com](https://grpc-og.papadritta.com)
- **WebSocket (WSS)**: [ws://wss-og.papadritta.com](ws://wss-og.papadritta.com)
- **kv**: [https://kv-og.papadritta.com](https://kv-og.papadritta.com)
- **Storage**: [https://storage-og.papadritta.com](https://storage-og.papadritta.com)

![1](https://github.com/papadritta/og-protocol-services/assets/90826754/44003484-ed9a-4e48-a598-bfe258366c35)

## Script for quick NODE OG Installation (v0.2.3)

- You can use a Script for quick `NODE OG` [Installation](box/starter.md)

>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

#### Check node sync status
```
0gchaind status | jq '.sync_info'
```
> check node status > false > [add/check vars](configs/vars.properties) > [Create a Validator](configs/Validator.properties)

#### Wait until the node is fully synced or download the Snapshot 

- **Fresh Snapshot**: [Update every 3 hours](box/Snapshot.md)

#### Check lastest block
```
curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://rpc-og.papadritta.com | jq -r '.result' | xargs printf "%d\n"
```

![2](https://github.com/papadritta/og-protocol-services/assets/90826754/2afad023-c7f6-49c1-a2d0-fde81d6133b0)

## Script for quick STORAGE NODE OG Installation Run on the same server with NODE OG.

- You can use a Script for quick `STORAGE NODE OG` [Installation](box/starter.md)

## Additional:

#### Metamask Chain OG sets:
```
Network name : 0g Chain Testnet
New RPC URL : https://rpc-testnet.0g.ai
Chain ID : 16600
Currency symbol: A0GI
Block explorer URL (Optional) : https://scan-testnet.0g.ai/
```
#### Backup & Restore all Node info exept data dir (the priv_validator_state.json is also stored in backup)
- You can use a Script for quick `BACKUP NODE OG` & `RESTORE NODE OG` before & after hardfork [Backup](box/backup_restore.md) and then [Restore](box/backup_restore.md)


