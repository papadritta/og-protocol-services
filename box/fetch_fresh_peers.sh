#!/bin/bash

# Function to fetch and display fresh peers from the specified RPC endpoint
fetch_fresh_peers() {
  local rpc_url="$1"

  # Fetch the list of fresh peers from the RPC endpoint
  response=$(curl -s "$rpc_url/net_info")

  # Print the raw response for debugging
  echo "Raw response from RPC endpoint:"
  echo "$response"

  # Check if the response is valid JSON
  if ! echo "$response" | jq -e . >/dev/null 2>&1; then
    echo "Invalid JSON response from RPC endpoint: $rpc_url"
    return 1
  fi

  # Extract the peers
  peers=$(echo "$response" | jq -r '.result.peers[].node_info.listen_addr' | paste -sd "," -)

  if [ -z "$peers" ]; then
    echo "No peers found from RPC endpoint: $rpc_url"
    return 1
  fi

  # Display the fresh peers
  echo "Fresh peers from RPC endpoint $rpc_url:"
  echo "$peers"

  # Commented out: Update the config.toml file
  # config_file="$HOME/.your_project/config/config.toml"
  # sed -i.bak -e "s/^persistent_peers *=.*/persistent_peers = \"$peers\"/" "$config_file"
  # echo "Config file updated: $config_file"

  return 0
}

# Check if an RPC URL was provided
if [ -z "$1" ]; then
  echo "Usage: $0 <rpc_url>"
  exit 1
fi

# Fetch fresh peers from the specified RPC endpoint
fetch_fresh_peers "$1"

