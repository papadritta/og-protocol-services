####  Create a validator
```
0gchaind tx staking create-validator \
  --amount=1000000ua0gi \
  --pubkey=$(0gchaind tendermint show-validator) \
  --moniker=$MONIKER \
  --chain-id=$CHAIN_ID_OG \
  --commission-rate=0.10 \
  --commission-max-rate=0.20 \
  --commission-max-change-rate=0.01 \
  --min-self-delegation=1 \
  --from=$WALLET_NAME \
  --identity=$IDENTITY \
  --website=$WEBSITE \
  --security-contact=$EMAIL \
  --details=$DETAILS \
  --gas=auto --gas-adjustment=1.4 \
  -y
```