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
- **P2P Persistent Peer**: `6ebfc7a8a4a02f9f92b34d0b91d0a4ef7ea5f264@212.220.110.72:26656,57c1b2d83f6eeb5cca55225cbdb57aa8c72cd854@135.181.5.169:45656,70a24ce7e35bcfa53dd180807c45f483bea598f8@46.56.82.134:26656,3bab7f220e34efca9a1172154f981d3198ba53bb@188.166.210.83:33656,cfe299faebfa81a2a4191ff93c8f6136887238da@185.250.36.142:26656,b9d9e4513f860eebc77f683c72747a4f132fbf69@95.171.21.37:26656,1d138c148692ab5830fc99979f6d376e25994a50@213.199.41.243:26656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,f5bbd3faa0d85ca7a4348c7da6b7b6cf577284c1@77.237.237.177:16656,8956c62a1e02a7798da2007c408fe011fbb6ab28@65.21.69.53:14256,f74f30c49de0ceb02139939c8e602314b343ff61@78.132.140.239:26656,31060efa26f8d8e80db3250ceb59a6d01021930d@45.67.213.149:26656,928f42a91548484f35a5c98aa9dcb25fb1790a70@65.109.155.238:26656,498089b71f268bde4b038a7c9796465e09070e5b@45.15.253.182:26656,ebaccf331df166fe6f5579d190d08776f8c5004d@45.67.212.83:26656`

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




