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

# Services:

## Configuration Parameters
This section details the specific configuration parameters set for the OG Services.

| Parameter          | Value                                    |
| ------------------ | ---------------------------------------- |
| `indexing`         | kv                                       |
| `pruning`          | custom (100/50)                          |
| `min-retain-blocks`| 0                                        |
| `snapshot-interval`| 2000                                     |
| `snapshot-keep-recent` | 2                                    |
| `minimum-gas-prices`  | 0.00252ua0gi                          |

## Access Points
Services provide various endpoints for access and interaction through different protocols:

- **RPC**: [http://rpc-og.papadritta.com](http://rpc-og.papadritta.com) or [http://rpc-og.papadritta.com:8545](http://rpc-og.papadritta.com:8545)
- **REST API**: [api-og.papadritta.com](api-og.papadritta.com)
- **WebSocket (WSS)**: [wss-og.papadritta.com](ws://wss-og.papadritta.com:8546)
- **gRPC**: [grpc-og.papadritta.com](grpc-og.papadritta.com)
- **kv**: [kv-og.papadritta.com](kv-og.papadritta.com)
- **Storage**: [storage-og.papadritta.com](storage-og.papadritta.com)

## Network Fresh Peers [fetch_script]()
- **P2P Persistent Peer**: `84.247.188.207:26656,195.201.195.156:12656,tcp://0.0.0.0:27656,tcp://0.0.0.0:26656,tcp://0.0.0.0:26656,158.220.104.114:16656,81.17.97.90:26656,75.119.130.213:26656,95.111.227.231:12656,tcp://0.0.0.0:26656,tcp://0.0.0.0:26656,tcp://0.0.0.0:26656,tcp://0.0.0.0:26656,109.199.97.246:12656,91.108.244.154:26656,84.247.185.151:26656,tcp://0.0.0.0:14256,tcp://0.0.0.0:26656,144.91.113.114:12656,tcp://0.0.0.0:26656,81.17.96.173:26656,95.217.113.104:56656,65.109.115.15:16656,75.119.145.247:26656,tcp://0.0.0.0:26656,193.233.75.129:26656,138.68.70.4:26656,tcp://0.0.0.0:26656,80.71.227.82:26656,tcp://0.0.0.0:27656,tcp://0.0.0.0:26656,tcp://0.0.0.0:26656,75.119.137.90:16656,tcp://0.0.0.0:26656,193.34.213.225:12656,83.246.196.57:26656,65.109.83.40:28356,tcp://0.0.0.0:26656,tcp://0.0.0.0:13456,185.103.100.198:26656,213.199.37.69:12656,tcp://0.0.0.0:26656,81.17.96.108:26656,213.199.37.64:12656,158.220.104.195:16656,95.111.232.201:12656,5.9.148.136:12656,193.203.15.150:12656,185.213.25.148:12656`

## Script for quick NODE OG Installation
```
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/box/run.sh && chmod +x run.sh && ./run.sh
```
#### Check node sync status
```
0gchaind status | jq '.sync_info'
```
> check node status > false > [add vars](box/vars.properties) > [Create a Validator](box/Create_a_Validator.md)

## STORAGE NODE OG [Installation](box/storage_node.md)

#### Metamask Chain OG sets:
```
Network name : 0g Chain Testnet
New RPC URL : https://rpc-testnet.0g.ai
Chain ID : 16600
Currency symbol: A0GI
Block explorer URL (Optional) : https://scan-testnet.0g.ai/
```

## State Management
- **State Sync**: [Guide](URL)
- **Fresh Snapshot**: [Guide](URL) (Being updated every 5 hours)
- **Fresh Addrbook**: [Guide](URL) (Being updated every 15 minutes)

## Live Monitoring Tools
- **Live Peers Scanner**: [Guide](URL) (Being updated every 5 minutes)

## Updates and Maintenance
For further details on updates, maintenance schedules, and historical data, refer to the specific guides linked above.




