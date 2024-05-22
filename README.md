<img src="https://github.com/papadritta/og-protocol-services/assets/90826754/5ec4b835-bb11-44d2-85d6-a644b6e6916e" width="300" alt="OG Logo">


# og-protocol-services
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

## Network Fresh Peers
- **P2P Persistent Peer**: `1d335ea9c78e131a63294a88cc5313e1dcdedba4@157.173.192.8:26656,9e2febd1c051e695e99d0180141f13eb7da128a6@75.119.152.232:26656,8f1880f4140e3d8187d0d0ac003e10443f9216b0@89.117.55.63:26656,4302973bbbe8158a07fcfd49922a915f1461830a@14.245.25.144:14256,fe1dbb596ca2001c1e4da85fdcb355122bad1e2e@213.199.53.225:26656,71ecf31f8ad1ead7af4fa37b594c6402ac3619c8@5.189.131.119:26656,09276ca89027a4357ea7e68d0bfc25e58fe77377@176.126.87.189:26656,840be9da0743cb195519fb48848d571598f46b87@88.198.82.151:26656,22a91d85cbd25a74a46ffe471611bfc11a43eb3c@45.77.168.91:26656,e2f0de202df1770b8e7e2780e1562e138caaf8a6@62.169.18.171:26656,fde6660ee4551f36ffefe549fefb4aa093ac7f29@194.35.120.148:12656,b4bb8314c40e943f1744b5cffa61e83cfbdc6391@84.247.171.3:26656,b962d4afb587406e20b9cbd8f017e330d3f9a8ff@51.91.74.124:26656,59632db72eb32c14f2f66c2fd894ede80db4b1c0@23.95.193.146:26656,272c47767cc5a869090d28b4f75d281318ad999a@37.60.231.42:26656`

## Script for quick NODE OG Installation
```
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/box/run.sh && chmod +x run.sh && ./run.sh
```
#### Check node sync status
```
0gchaind status | jq '.sync_info'
```
> check node status > false > [add vars](og-protocol-services/box/vars.properties) > [Create a Validator](og-protocol-services/box/Create_a_Validator.md)

## STORAGE NODE OG [Installation](og-protocol-services/box/storage_node.md)

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




