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

## Repository Root
```
og-protocol-services
│
├── README.md                       # Overview and general information
├── LICENSE                         # Legal licensing information for the repository
│
├── docs                            # Documentation
│   ├── configuration_parameters.md # Configuration Parameters details
│   ├── access_points.md            # Access Points details
│   ├── metamask_chain_settings.md  # MetaMask Chain OG settings
│   ├── state_management.md         # State Management guides
│   ├── live_monitoring_tools.md    # Live Monitoring Tools details
│   ├── updates_and_maintenance.md  # Updates and maintenance schedules
│   ├── peers.md                    # Peer configurations and scripts
│
├── scripts                         # Scripts for various operations
│   ├── install_node.sh             # Script for quick NODE OG Installation
│   ├── check_sync_status.sh        # Script to check node sync status
│   ├── check_block.sh              # Script to check the latest block
│
├── services                        # Directory for various services
│   ├── kv                          # Key-Value store service configurations and scripts
│   ├── rpc                         # RPC service configurations and scripts
│   ├── storage-node                # Storage node service configurations and scripts
│   ├── peers                       # Peer configurations and scripts
│   ├── snapshots                   # Snapshot configurations and scripts
│
└── network                         # Network configuration and scripts
    ├── fresh_peers.md              # Network Fresh Peers details
    └── fetch_peers_script.sh       # Script to fetch fresh peers
```
![3](https://github.com/papadritta/og-protocol-services/assets/90826754/5b4b6b87-5fd4-4e71-a0fe-c702f6b333b3)
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
- **P2P Persistent Peer**: `1b1d5996e51091b498e635d4ee772d3951e54d47@62.171.142.222:12656,3b0fd60499e74b773b85f4741d6b934f5e226912@158.220.109.208:12656,3cbb3424411d1131a40dd867ef01fd3fc505bed0@77.237.238.41:33556,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,e0f225fb7356ab47328277f0a3df0e81e9ba67e3@65.109.35.243:26656,bccca94165140b3507bcee0982508c819671b1db@95.217.113.104:56656,8956c62a1e02a7798da2007c408fe011fbb6ab28@65.21.69.53:14256,4908344350e7792a1c462dc4f1e779c2fd3d0566@45.140.185.171:12656,d1f036c8cabf9c51d85e4f03f4e313ca6b39cf27@207.180.254.230:12656,acff2b2b3c01d4903cdfd61cc9d2d0c4383f4dc4@65.108.245.136:26656,4aef094b685ab73031093f01723a63e9d1d308d9@62.169.31.83:26656,892d98c9400c0f913fe689274b56827660fe2e58@157.173.200.31:13456,4a0010b186d3abc0aad75bb2e1f6743d6684b996@116.202.196.217:12656,de24f369f6ce5e4874a9f935d0dd2949f6e62af7@95.217.104.49:37656,b8f8ed478f2794629fdb5cf0c01edaed80f00f84@168.119.64.172:26656`

![1](https://github.com/papadritta/og-protocol-services/assets/90826754/44003484-ed9a-4e48-a598-bfe258366c35)

## Script for quick NODE OG Installation
>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

```
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/box/run.sh && chmod +x run.sh && ./run.sh
```
#### Check node sync status
```
0gchaind status | jq '.sync_info'
```
> check node status > false > [add vars](box/vars.properties) > [Create a Validator](box/Create_a_Validator.md)

#### Check lastest block
```
curl -s -X POST -H "Content-Type: application/json" --data '{"jsonrpc":"2.0","method":"eth_blockNumber","params":[],"id":1}' http://rpc-og.papadritta.com | jq -r '.result' | xargs printf "%d\n"
```

![2](https://github.com/papadritta/og-protocol-services/assets/90826754/2afad023-c7f6-49c1-a2d0-fde81d6133b0)

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




