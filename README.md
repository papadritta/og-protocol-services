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
- **P2P Persistent Peer**: `1e1c401922083ceeae8e937ca7be11ec2d50373b@172.245.159.158:26656,490387520122b66dd8b3d575f982583626c56a12@158.220.90.132:26656,3b0fd60499e74b773b85f4741d6b934f5e226912@158.220.109.208:12656,3cbb3424411d1131a40dd867ef01fd3fc505bed0@77.237.238.41:33556,93704e194d82e4a5b120a2e02fe39f884ceb40cd@108.61.5.6:13456,b2f647c3704b04b03700b67fcca7477d3f3d4c9b@173.212.242.60:26656,2d1f251c61b707e2c3521b1f5d8d431765366bfd@193.233.164.82:26656,e0f225fb7356ab47328277f0a3df0e81e9ba67e3@65.109.35.243:26656,bccca94165140b3507bcee0982508c819671b1db@95.217.113.104:56656,8956c62a1e02a7798da2007c408fe011fbb6ab28@65.21.69.53:14256,8cecd90d6d0d2d64afea9735dbab5e6e21e7bf6f@195.179.229.40:26656,4908344350e7792a1c462dc4f1e779c2fd3d0566@45.140.185.171:12656,56715db4fbe48028778ebb7cfeeeb689d0d2fb9b@37.60.252.203:26656,928f42a91548484f35a5c98aa9dcb25fb1790a70@65.109.155.238:26656,32f048b9de0f7748c794b8bb2f825d012cf7862b@175.211.36.30:26656`

## Script for quick NODE OG Installation
```
wget -O run.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/box/run.sh && chmod +x run.sh && ./run.sh
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




