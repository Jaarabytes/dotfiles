#!/bin/bash     


# This is a simple bash script that tries to connect to vpn servers, (most WI-Fi's in my local visiting areas have mad firewalls. I can't even access gitlab)

#packages to install
packages=(wireguard openvpn)
#server configuration files
function evadeThem(){
# since you have cloned the repo, i assume that the open vpn and wireguard config files already exist.
  for package in "${packages[@]}"; do
    echo "Installing $package"
      if sudo apt install $package; then
        echo "Successfully installed $package"
      else 
        echo "Error installing $package"
      fi
  done
  echo "Updating system"
  if sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y; then
    echo "System successfully updated"
  else
    echo "Error updating system"
  fi
}

function wireguardConnect() {
  #since wireguard and openvpn are installed, connect to vpn server configs, i'm using wireguard for now;
  sudo cp ovpn/* /etc/wireguard/
  echo "Successfully copied conf files to /etc/wireguard"
  echo"Now connecting to config files"
  
  # get all config files from /etc/wireguard
  configs=($(ls /etc/wireguard/*.conf 2>/dev/null))
   
  if [[ ${#configs[@]} -eq 0 ]]; then
    echo "No config files in /etc/wireguard/"
    return 1
  fi  


for config in "{$configs[@]}"; do
    config_name=$(basename "$config" .conf)
    echo "Attempting to connect to $config_name"
    if sudo wg-quick up "$config_name"; then
      echo "Successfully connected to $config_name"
      return 0
    else
      echo "Failed to connect to $config_name. Connecting to other VPN config"
done

  echo "Failed to connect to wireguard configuration"
  return 1
}

function ovpnConnect() {
  #this one does the same but connects using open vpn files
  
  ovpn_files=($(ls ovpn/*.ovpn))
  if [[ ${#ovpn_files[@]} -eq 0 ]]; then
    echo "No open vpn files here, bye"
    return 0
  fi  


  for ovpn_file in "{$ovpn_files[@]}"; do 
    echo "Attempting to connect to open vpn files now"
    if openvpn "$ovpnfile"; then
      echo "Successfully connected"
      return 0
    else
      echo "Failed to connect, Attempting others"
  done
}

evadeThem
wireguardConnect
ovpnConnect
