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

- **RPC**: [https://rpc-og.papadritta.com](https://rpc-og.papadritta.com) or [http://rpc-og.papadritta.com:8545](http://rpc-og.papadritta.com:8545)
- **REST API**: [api-og.papadritta.com](api-og.papadritta.com)
- **WebSocket (WSS)**: [wss-og.papadritta.com](ws://wss-og.papadritta.com:8546)
- **gRPC**: [grpc-og.papadritta.com](grpc-og.papadritta.com)
- **kv**: [kv-og.papadritta.com](kv-og.papadritta.com)
- **Storage**: [storage-og.papadritta.com](storage-og.papadritta.com)

## Network Fresh Peers [fetch_script]()
- **P2P Persistent Peer**: `1b1d5996e51091b498e635d4ee772d3951e54d47@62.171.142.222:12656,3b0fd60499e74b773b85f4741d6b934f5e226912@158.220.109.208:12656,3cbb3424411d1131a40dd867ef01fd3fc505bed0@77.237.238.41:33556,adb020421007751d1fa3fe779796460e3889839e@161.97.94.69:12656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,8956c62a1e02a7798da2007c408fe011fbb6ab28@65.21.69.53:14256,a7cd7ef5b92e1b649dd4105d373dae3d563cfbd2@188.40.127.95:26656,caf554a43fec67ad4e22ede2924c8ebff4eefbbd@4.213.58.235:13456,4a0010b186d3abc0aad75bb2e1f6743d6684b996@116.202.196.217:12656,52b1994a0684ec18302039ee1d3b7b4b4583da4c@84.247.128.194:12656,aa136118f8958b14abf1428ef0f376db97165f40@77.237.240.21:26656,3734b9356dadb67f880dd6c2b3c54a76ec5eb182@37.60.224.149:26656,2b5e2dcb5a307529f064b08137e70295785df547@38.242.210.236:26656,d7fa28ebd8d704931810feca143961da973e12b8@37.61.220.75:12656,916f2d67af81003d419924b4979890561321b347@167.235.72.90:12656`

![1](https://github.com/papadritta/og-protocol-services/assets/90826754/44003484-ed9a-4e48-a598-bfe258366c35)

## Script for quick NODE OG Installation
1. You can use a Script for quick STORAGE NODE OG Installation
```
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/box/run.sh && chmod +x run.sh && ./run.sh
```
>Tested on Ubuntu 24.04 LTS (GNU/Linux 6.8.0-31-generic x86_64)

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

## STORAGE NODE OG 
1. Full step-by-step Guide you can find here in [Installation](box/storage_node.md)
2. If you want to run a STORAGE Node on the same server where the main OG Node installed, you can use a Script for quick STORAGE NODE OG Installation
```
wget -O storage.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/box/storage.sh && chmod +x storage.sh && ./storage.sh
```

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




