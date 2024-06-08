# Example how to mapping the ports for different chains in one server

| Project Name | Project Path | Configuration Files            | Port Mappings                                                                | Used Ports          |
|--------------|--------------|--------------------------------|------------------------------------------------------------------------------|---------------------|
| 0g         | $HOME/.0gchain  | $HOME/.0gchain/config/config.toml | 26658 > 30658, 26657 > 30657, 6060 > 6460, 26656 > 30656, 26660 > 30660      | 30658, 30657, 6460, 30656, 30660 |
|              |              | $HOME/.0gchain/config/app.toml    | 9090 > 9490, 9091 > 9491, 1317 > 1717, 8545 > 8945, 8546 > 8946, 6065 > 6465 | 9490, 9491, 1717, 8945, 8946, 6465 |
|              |              | $HOME/.0gchain/config/client.toml | 26657 > 30657                                                                | 30657              |
| ...          | ...          | ...                            | ...                                                                          | ...                |


# Example how to mapping the ports for different chains in one server

| Project Name | Project Path     | Configuration Files            | Port Mappings                                                                | Used Ports                      |
|--------------|------------------|--------------------------------|------------------------------------------------------------------------------|---------------------------------|
| 0gchain      | $HOME/.0gchain   | $HOME/.0gchain/config/config.toml | 26658 > 30658, 26657 > 30657, 6060 > 6460, 26656 > 30656, 26660 > 30660      | 30658, 30657, 6460, 30656, 30660 |
|              |                  | $HOME/.0gchain/config/app.toml    | 9090 > 9490, 9091 > 9491, 1317 > 1717, 8545 > 8945, 8546 > 8946, 6065 > 6465 | 9490, 9491, 1717, 8945, 8946, 6465 |
|              |                  | $HOME/.0gchain/config/client.toml | 26657 > 30657                                                                | 30657                            |
| project1     | $HOME/.project1  | $HOME/.project1/config/config.toml | 27658 > 31658, 27657 > 31657, 6160 > 6560, 27656 > 31656, 27660 > 31660      | 31658, 31657, 6560, 31656, 31660 |
|              |                  | $HOME/.project1/config/app.toml    | 9190 > 9590, 9191 > 9591, 1417 > 1817, 8645 > 9045, 8646 > 9046, 6165 > 6565 | 9590, 9591, 1817, 9045, 9046, 6565 |
|              |                  | $HOME/.project1/config/client.toml | 27657 > 31657                                                                | 31657                            |
| project2     | $HOME/.project2  | $HOME/.project2/config/config.toml | 28658 > 32658, 28657 > 32657, 6260 > 6660, 28656 > 32656, 28660 > 32660      | 32658, 32657, 6660, 32656, 32660 |
|              |                  | $HOME/.project2/config/app.toml    | 9290 > 9690, 9291 > 9691, 1517 > 1917, 8745 > 9145, 8746 > 9146, 6265 > 6665 | 9690, 9691, 1917, 9145, 9146, 6665 |
|              |                  | $HOME/.project2/config/client.toml | 28657 > 32657                                                                | 32657                            |


# Setup for each Chain or Servises:

#### 0gchain Chain
```
sed -i.bak -e "s%:26658%:30658%; s%:26657%:30657%; s%:6060%:6460%; s%:26656%:30656%; s%:26660%:30660%" $HOME/.0gchain/config/config.toml && sed -i.bak -e "s%:9090%:9490%; s%:9091%:9491%; s%:1317%:1717%; s%:8545%:8945%; s%:8546%:8946%; s%:6065%:6465%" $HOME/.0gchain/config/app.toml && sed -i.bak -e "s%:26657%:30657%" $HOME/.0gchain/config/client.toml
```
#### project1 Chain
```
sed -i.bak -e "s%:27658%:31658%; s%:27657%:31657%; s%:6160%:6560%; s%:27656%:31656%; s%:27660%:31660%" $HOME/.project1/config/config.toml && \
sed -i.bak -e "s%:9190%:9590%; s%:9191%:9591%; s%:1417%:1817%; s%:8645%:9045%; s%:8646%:9046%; s%:6165%:6565%" $HOME/.project1/config/app.toml && \
sed -i.bak -e "s%:27657%:31657%" $HOME/.project1/config/client.toml
```
#### project2 Chain
```
sed -i.bak -e "s%:28658%:32658%; s%:28657%:32657%; s%:6260%:6660%; s%:28656%:32656%; s%:28660%:32660%" $HOME/.project2/config/config.toml && \
sed -i.bak -e "s%:9290%:9690%; s%:9291%:9691%; s%:1517%:1917%; s%:8745%:9145%; s%:8746%:9146%; s%:6265%:6665%" $HOME/.project2/config/app.toml && \
sed -i.bak -e "s%:28657%:32657%" $HOME/.project2/config/client.toml
```