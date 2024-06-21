<p align="center">
  <img src="https://github.com/papadritta/og-protocol-services/assets/90826754/5ec4b835-bb11-44d2-85d6-a644b6e6916e" width="400" alt="OG Logo">
</p>

# OG protocol 'Testnet Newton' services
Repo with public services for OG: kv, RPC, storage-node, peers, snapshots etc

#### 0G Testnet Newton
```
Chain Id: zgtendermint_16600-1
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

## Access Points
Services provide various endpoints for access and interaction through different protocols:

- **RPC**: [https://rpc-og.papadritta.com](https://rpc-og.papadritta.com)
- **REST API**: [https://api-og.papadritta.com](https://api-og.papadritta.com)
- **gRPC**: [https://grpc-og.papadritta.com](https://grpc-og.papadritta.com)
- **WebSocket (WSS)**: [ws://wss-og.papadritta.com](ws://wss-og.papadritta.com)
- **kv**: [https://kv-og.papadritta.com](https://kv-og.papadritta.com)
- **Storage**: [https://storage-og.papadritta.com](https://storage-og.papadritta.com)

## Network Fresh Peers [fetch_script](box/fetch_fresh_peers.sh) **(TBA)**
- **P2P Persistent Peer**: `7379543f98e0015dcf53b3eaa596138fb9c75fca@83.246.253.4:26656,2dacc36d2458627d7b972e1cf76ce5c28550f322@185.252.232.16:26656,cfe299faebfa81a2a4191ff93c8f6136887238da@185.250.36.142:26656,fd5b7f303e24649dcfb7ea5251b3ba65189c6623@158.220.115.143:12656,b2f647c3704b04b03700b67fcca7477d3f3d4c9b@173.212.242.60:26656,adb020421007751d1fa3fe779796460e3889839e@161.97.94.69:12656,334a34478c82e8669aace6f1ee04b4c3e04a50bb@92.118.56.200:26656,3c820ec2075e297c013b2e2f083f6c15a4fad594@62.169.26.95:26656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,56715db4fbe48028778ebb7cfeeeb689d0d2fb9b@37.60.252.203:26656,8cecd90d6d0d2d64afea9735dbab5e6e21e7bf6f@195.179.229.40:26656,01f53ba9f8b1f1cbcd274c52751136a741633187@5.189.142.98:26656,8f1880f4140e3d8187d0d0ac003e10443f9216b0@89.117.55.63:26656,f397ebb8b1180d71c47e69fa685d1cf525769031@45.94.209.123:26656,ac25a6be1272692d3fc73dc84b749df870072370@5.189.146.123:26656`

## Example how to mapping the ports for different chains in one [server](box/ports_ufw_rules.md) 

![1](https://github.com/papadritta/og-protocol-services/assets/90826754/44003484-ed9a-4e48-a598-bfe258366c35)

## Script for quick NODE OG Installation (v0.1.0)

- You can use a Script for quick `NODE OG` [Installation](/starter.md)

>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

#### Check node sync status
```
0gchaind status | jq '.sync_info'
```
> check node status > false > [add/check vars](box/vars.properties) > [Create a Validator](box/Validator.properties)

#### Wait until the node is fully synced or download the Snapshot 

- **Fresh Snapshot**: [Update every 3 hours](box/Snapshot.md)

#### Check lastest block
```
curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://rpc-og.papadritta.com | jq -r '.result' | xargs printf "%d\n"
```

![2](https://github.com/papadritta/og-protocol-services/assets/90826754/2afad023-c7f6-49c1-a2d0-fde81d6133b0)

## Script for quick STORAGE NODE OG Installation (v0.3.1) Run on the same server with NODE OG.

- You can use a Script for quick `STORAGE NODE OG` [Installation](/starter.md)

#### Metamask Chain OG sets:
```
Network name : 0g Chain Testnet
New RPC URL : https://rpc-testnet.0g.ai
Chain ID : 16600
Currency symbol: A0GI
Block explorer URL (Optional) : https://scan-testnet.0g.ai/
```
#### Backup & Restore all Node info exept data dir (the priv_validator_state.json is also stored in backup)
- You can use a Script for quick `BACKUP NODE OG` & `RESTORE NODE OG` before & after hardfork [Backup]() and then [Restore]()


