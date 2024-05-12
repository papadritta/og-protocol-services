<img src="https://github.com/papadritta/og-protocol-services/assets/90826754/5ec4b835-bb11-44d2-85d6-a644b6e6916e" width="300" alt="OG Logo">


# og-protocol-services
Repo with public services for OG: kv, RPC, storage-node, peers, snapshots etc

#### Official links:
- 0G Testnet Newton Onboarding: [https://tinyurl.com/4eyjk5fe](https://tinyurl.com/4eyjk5fe)
- 0G gitbook/docs: [https://zerogravity.gitbook.io/0g-doc](https://zerogravity.gitbook.io/0g-doc/)
- OG Github repo: [https://github.com/0glabs](https://github.com/0glabs)
- 0G Youtube Channel: [https://www.youtube.com/@0G_Labs](https://www.youtube.com/@0G_Labs)
- 0G Faucet Link: [https://faucet.0g.ai](https://faucet.0g.ai/)
- 0G Scan: [https://scan-testnet.0g.ai](https://scan-testnet.0g.ai/)

#### Update peers
```
PEERS="a6793407e171fae187579746511e11d0557ea11a@92.118.57.159:26656,55d2f01f9e1e8f5e3e3345c27993e3dc2fe577a8@144.91.84.195:26656,4663c456f6b6e06fd96a4c26371407a509943b02@37.60.224.165:16656,913d912cc72365ea322fd1d71c5d5b2f83b22cea@167.86.122.232:16656,1072b00c5f3cd39391f0ccb2af190b969fe17ce3@37.60.228.18:26656,d2cd9e5b011e2321ebb58bdd7a49b660b82e67b0@80.71.227.77:26656,0a0b54852a271923277b03366a1f0a1dacbcd464@109.199.102.47:26656,3f8076b8d794832cf92c4a498bdbed4e88722d03@62.171.154.11:16656,5ee69001a49e9fad7f60cad99f0a91d823810757@82.67.49.126:37000,eaf7a1e80d2ecdec18871d444cf670f470f5c432@91.108.245.67:26656,2e408c120713ddae88fe73ec47417bb039733b50@193.233.80.119:26656,fd58eeed438ddcac5d58d6221aeb940dfa70658f@77.237.239.110:26656,38154d89b8dc8496e20a0ef999e096ed03cae774@65.21.141.117:43656,49d65a261fc0c32b9d83ef5eb9ae52215d80a16a@185.239.209.110:16656,c4bda9a255f8965cf7575f8662c0c2c6ec298b0b@31.220.87.206:39656" && \
sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$PEERS\"/" $HOME/.0gchain/config/config.toml && \
sudo systemctl restart 0gchaind && sudo journalctl -u 0gchaind -f -o cat
```
```
curl -s localhost:26657/status | jq .result.sync_info
```
