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

## or run a script `ports_mapper.sh` to install or check ports in use (for Cosmos SDK related projects & common used Ports)

#### How to Use:
**!WARNING!**: Safe mode is always hit the 'Enter'
1. Copy-and-paste the script, it will download script and run it automaticly, choose your option: for remap ports 'Y/y' or hit Enter to check ports in use. (It's a safe mode to use script - just hit always Enter.).
2. When you have any conflicts between ports and projects, you can choose option - install 'Y/y' and script ask you which project do you need to remap and change each port by confirmation 'Y/y', (To skip, just always hit the Enter).
3. To re-run script again use: `./ports_mapper.sh`

```
wget -O ports_mapper.sh https://raw.githubusercontent.com/papadritta/og-protocol-services/main/box/ports_mapper.sh && chmod +x ports_mapper.sh && ./ports_mapper.sh
```

## State Management **(TBA)**
- **State Sync**: [Link](URL)
- **Fresh Addrbook**: [Link](URL) (Being updated every 15 minutes)

## Live Monitoring Tools **(TBA)**
- **Validators Dashboard**: [Link](URL) (Being updated every 5 minutes)

