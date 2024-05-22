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

- **RPC**: [rpc-og.papadritta.com](rpc-og.papadritta.com) or [http://rpc-og.papadritta.com:8545](http://rpc-og.papadritta.com:8545)
- **REST API**: [api-og.papadritta.com](api-og.papadritta.com)
- **WebSocket (WSS)**: [wss-og.papadritta.com](ws://wss-og.papadritta.com:8546)
- **gRPC**: [grpc-og.papadritta.com](grpc-og.papadritta.com)
- **kv**: [kv-og.papadritta.com](kv-og.papadritta.com)
- **Storage**: [storage-og.papadritta.com](storage-og.papadritta.com)

## Network Fresh Peers
- **P2P Persistent Peer**: `57c1b2d83f6eeb5cca55225cbdb57aa8c72cd854@135.181.5.169:45656,9e2febd1c051e695e99d0180141f13eb7da128a6@75.119.152.232:26656,1d138c148692ab5830fc99979f6d376e25994a50@213.199.41.243:26656,e776d3cd2e2c1223f3ad00af2fa7f85173609019@185.103.100.198:26656,ebaccf331df166fe6f5579d190d08776f8c5004d@45.67.212.83:26656,d2cd9e5b011e2321ebb58bdd7a49b660b82e67b0@80.71.227.77:26656,09276ca89027a4357ea7e68d0bfc25e58fe77377@176.126.87.189:26656,9087a83002cbacaaa1cc7532c086410fa89d3a70@88.198.52.89:64656,e2f0de202df1770b8e7e2780e1562e138caaf8a6@62.169.18.171:26656,3492fde06a28171cb8e257a5a00448ae10ef9d68@194.163.157.109:12656,fde6660ee4551f36ffefe549fefb4aa093ac7f29@194.35.120.148:12656,2b5e2dcb5a307529f064b08137e70295785df547@38.242.210.236:26656,773a0b5f35225210c0f04d78bf28bed2836c13c5@38.242.156.74:26656,c024d83af04b34f9afef7d6f8b00343978174a1c@37.27.117.171:26656,5d2074e5a5631c4b95b06a1469439e6a2dad0961@212.192.26.234:26656`

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




