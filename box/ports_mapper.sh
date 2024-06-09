#!/bin/bash

# Function to check if a port is in use using ss command
is_port_in_use() {
  ss -tulpen | awk '{print $5}' | grep -q ":$1$"
}

# Function to adjust ports in config files
adjust_ports() {
  local config_path="$HOME/.$project_name/config/config.toml"
  local app_path="$HOME/.$project_name/config/app.toml"
  local client_path="$HOME/.$project_name/config/client.toml"

  if [[ -f "$config_path" && -f "$app_path" && -f "$client_path" ]]; then
    sed -i.bak -e "s%:26656%:$1%; s%:26657%:$2%; s%:26658%:$3%; s%:6060%:$4%; s%:1317%:$5%; s%:9090%:$6%; s%:9091%:$7%; s%:8545%:$8%; s%:8546%:$9%" "$config_path"
    sed -i.bak -e "s%:26656%:$1%; s%:26657%:$2%; s%:26658%:$3%; s%:6060%:$4%; s%:1317%:$5%; s%:9090%:$6%; s%:9091%:$7%; s%:8545%:$8%; s%:8546%:$9%" "$app_path"
    sed -i.bak -e "s%:26657%:$2%" "$client_path"
  else
    echo "Config files not found. Make sure the paths are correct."
    exit 1
  fi
}

# Function to print port bindings with project names
check_ports() {
  echo "Checking ports for up to 10 possible projects..."

  for i in {0..9}; do
    rpc_port=$((base_rpc_port + i * 1000))
    rpc_laddr_port=$((base_rpc_laddr_port + i * 1000))
    p2p_port=$((base_p2p_port + i * 1000))
    prometheus_port=$((base_prometheus_port + i * 1000))
    api_port=$((base_api_port + i * 100))
    grpc_port=$((base_grpc_port + i * 100))
    grpc_web_port=$((base_grpc_web_port + i * 100))
    evm_rpc_port=$((base_evm_rpc_port + i * 100))
    evm_rpc_ws_port=$((base_evm_rpc_ws_port + i * 100))

    project_name=""

    # Check for the existence of the project directory
    for dir in $HOME/.*; do
      if [[ -d "$dir" && -f "$dir/config/config.toml" ]]; then
        project_dir=$(basename "$dir")
        project_ports=$(grep -Eo ':[0-9]+' "$dir/config/config.toml" "$dir/config/app.toml" "$dir/config/client.toml" | grep -Eo '[0-9]+')
        if [[ $project_ports =~ $rpc_port || $project_ports =~ $rpc_laddr_port || $project_ports =~ $p2p_port || $project_ports =~ $prometheus_port || $project_ports =~ $api_port || $project_ports =~ $grpc_port || $project_ports =~ $grpc_web_port || $project_ports =~ $evm_rpc_port || $project_ports =~ $evm_rpc_ws_port ]]; then
          project_name=$project_dir
          break
        fi
      fi
    done

    if is_port_in_use $rpc_port || is_port_in_use $rpc_laddr_port || is_port_in_use $p2p_port || is_port_in_use $prometheus_port || is_port_in_use $api_port || is_port_in_use $grpc_port || is_port_in_use $grpc_web_port || is_port_in_use $evm_rpc_port || is_port_in_use $evm_rpc_ws_port; then
      echo "Project $(($i + 1)) ($project_name): Ports in use:"
      echo "  RPC $rpc_port"
      echo "  RPC laddr $rpc_laddr_port"
      echo "  P2P $p2p_port"
      echo "  Prometheus $prometheus_port"
      echo "  API $api_port"
      echo "  gRPC $grpc_port"
      echo "  gRPC(web) $grpc_web_port"
      echo "  EVM RPC $evm_rpc_port"
      echo "  EVM RPC (ws) $evm_rpc_ws_port"
    else
      echo "Project $(($i + 1)) (): No ports are in use."
    fi
  done
}

# Function to print port bindings
print_ports() {
  echo "Ports for project $project_name:"
  echo "  RPC $rpc_port"
  echo "  RPC laddr $rpc_laddr_port"
  echo "  P2P $p2p_port"
  echo "  Prometheus $prometheus_port"
  echo "  API $api_port"
  echo "  gRPC $grpc_port"
  echo "  gRPC(web) $grpc_web_port"
  echo "  EVM RPC $evm_rpc_port"
  echo "  EVM RPC (ws) $evm_rpc_ws_port"
}

# Define default ports
base_rpc_port=26656
base_rpc_laddr_port=26657
base_p2p_port=26658
base_prometheus_port=6060
base_api_port=1317
base_grpc_port=9090
base_grpc_web_port=9091
base_evm_rpc_port=8545
base_evm_rpc_ws_port=8546

# Prompt for mode
read -p "Do you want to remap ports? (Y/y to remap, Enter to check): " mode

# Convert mode to lowercase
mode=$(echo "$mode" | tr '[:upper:]' '[:lower:]')

if [[ "$mode" == "y" ]]; then
  # Prompt for project name
  read -p "Enter the project name: " project_name

  # Initialize ports
  rpc_port=$base_rpc_port
  rpc_laddr_port=$base_rpc_laddr_port
  p2p_port=$base_p2p_port
  prometheus_port=$base_prometheus_port
  api_port=$base_api_port
  grpc_port=$base_grpc_port
  grpc_web_port=$base_grpc_web_port
  evm_rpc_port=$base_evm_rpc_port
  evm_rpc_ws_port=$base_evm_rpc_ws_port

  # Check if ports are in use and adjust if necessary for up to 10 possible projects
  for i in {0..9}; do
    if is_port_in_use $rpc_port; then
      echo -e "\e[31mPort $rpc_port already in use.\e[39m"
      read -p "Do you want to remap port $rpc_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        rpc_port=$((base_rpc_port + (i + 1) * 1000))
      else
        echo "Port remapping skipped for $rpc_port."
      fi
    fi

    if is_port_in_use $rpc_laddr_port; then
      echo -e "\e[31mPort $rpc_laddr_port already in use.\e[39m"
      read -p "Do you want to remap port $rpc_laddr_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        rpc_laddr_port=$((base_rpc_laddr_port + (i + 1) * 1000))
      else
        echo "Port remapping skipped for $rpc_laddr_port."
      fi
    fi

    if is_port_in_use $p2p_port; then
      echo -e "\e[31mPort $p2p_port already in use.\e[39m"
      read -p "Do you want to remap port $p2p_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        p2p_port=$((base_p2p_port + (i + 1) * 1000))
      else
        echo "Port remapping skipped for $p2p_port."
      fi
    fi

    if is_port_in_use $prometheus_port; then
      echo -e "\e[31mPort $prometheus_port already in use.\e[39m"
      read -p "Do you want to remap port $prometheus_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        prometheus_port=$((base_prometheus_port + (i + 1) * 1000))
      else
        echo "Port remapping skipped for $prometheus_port."
      fi
    fi

    if is_port_in_use $api_port; then
      echo -e "\e[31mPort $api_port already in use.\e[39m"
      read -p "Do you want to remap port $api_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        api_port=$((base_api_port + (i + 1) * 100))
      else
        echo "Port remapping skipped for $api_port."
      fi
    fi

    if is_port_in_use $grpc_port; then
      echo -e "\e[31mPort $grpc_port already in use.\e[39m"
      read -p "Do you want to remap port $grpc_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        grpc_port=$((base_grpc_port + (i + 1) * 100))
      else
        echo "Port remapping skipped for $grpc_port."
      fi
    fi

    if is_port_in_use $grpc_web_port; then
      echo -e "\e[31mPort $grpc_web_port already in use.\e[39m"
      read -p "Do you want to remap port $grpc_web_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        grpc_web_port=$((base_grpc_web_port + (i + 1) * 100))
      else
        echo "Port remapping skipped for $grpc_web_port."
      fi
    fi

    if is_port_in_use $evm_rpc_port; then
      echo -e "\e[31mPort $evm_rpc_port already in use.\e[39m"
      read -p "Do you want to remap port $evm_rpc_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        evm_rpc_port=$((base_evm_rpc_port + (i + 1) * 100))
      else
        echo "Port remapping skipped for $evm_rpc_port."
      fi
    fi

    if is_port_in_use $evm_rpc_ws_port; then
      echo -e "\e[31mPort $evm_rpc_ws_port already in use.\e[39m"
      read -p "Do you want to remap port $evm_rpc_ws_port? (Y/y to remap, Enter to skip): " remap
      if [[ "$remap" == "Y" || "$remap" == "y" ]]; then
        evm_rpc_ws_port=$((base_evm_rpc_ws_port + (i + 1) * 100))
      else
        echo "Port remapping skipped for $evm_rpc_ws_port."
      fi
    fi
  done

  # Adjust ports in config files
  adjust_ports $rpc_port $rpc_laddr_port $p2p_port $prometheus_port $api_port $grpc_port $grpc_web_port $evm_rpc_port $evm_rpc_ws_port

  # Print new and previous port bindings
  print_ports

else
  check_ports
fi

# Instructions for re-running the script
echo -e "\nTo re-run the script again, use: ./ports_mapper.sh"
