# Example how to mapping the ports for different chains in one server

| Project Name | Project Path | Configuration Files            | Port Mappings                                                                | Used Ports          |
|--------------|--------------|--------------------------------|------------------------------------------------------------------------------|---------------------|
| 0g         | $HOME/.0gchain  | $HOME/.0gchain/config/config.toml | 26658 > 30658, 26657 > 30657, 6060 > 6460, 26656 > 30656, 26660 > 30660      | 30658, 30657, 6460, 30656, 30660 |
|              |              | $HOME/.0gchain/config/app.toml    | 9090 > 9490, 9091 > 9491, 1317 > 1717, 8545 > 8945, 8546 > 8946, 6065 > 6465 | 9490, 9491, 1717, 8945, 8946, 6465 |
|              |              | $HOME/.0gchain/config/client.toml | 26657 > 30657                                                                | 30657              |
| ...          | ...          | ...                            | ...                                                                          | ...                |

# Setup for each Chain or Servises:

#### 0gchain Chain
```
sed -i.bak -e "s%:26658%:30658%; s%:26657%:30657%; s%:6060%:6460%; s%:26656%:30656%; s%:26660%:30660%" $HOME/.0gchain/config/config.toml && sed -i.bak -e "s%:9090%:9490%; s%:9091%:9491%; s%:1317%:1717%; s%:8545%:8945%; s%:8546%:8946%; s%:6065%:6465%" $HOME/.0gchain/config/app.toml && sed -i.bak -e "s%:26657%:30657%" $HOME/.0gchain/config/client.toml
```
