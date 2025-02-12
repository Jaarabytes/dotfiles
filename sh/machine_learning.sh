#!/bin/bash

# Installs everything required for machine learning for either Arch-based or Debian-based systems

function install_pip() {
  local packages=("$@")  # More descriptive name than "pip"
  for package in "${packages[@]}"; do
    echo "Attempting to install $package via apt..."
    if sudo apt install -y "python3-${package}"; then
      echo "Successfully installed python3-$package via apt."
    else
      echo "Apt install failed. Trying pip3..."
      if sudo pip3 install --break-system-packages "$package"; then
        echo "Successfully installed $package via pip3."
      else
        echo "Error: Failed to install $package via both apt and pip3."
        return 1  # Exit with error code
      fi
    fi
  done
}
function update_arch() {
  echo "================"
  echo "Updating system"
  if sudo pacman -Syu --noconfirm; then
    echo "Successfully updated system"
  else
    echo "Error updating the system"
  fi
  echo "Installing python and pip"
  if sudo pacman -S python python-pip --noconfirm; then
    echo "Successfully installed python and pip"
  else
    echo "Error installing python and pip"
  fi
  echo "Installing system dependencies"
  if sudo pacman -S base-devel openssl --noconfirm; then
    echo "Successfully installed dependencies"
  else
    echo "Error installing dependencies"
  fi
  if install_pip "${pip[@]}"; then
    echo "Successfully installed all pip packages"
  else
    echo "Pip errors during installation"
  fi
  echo "++++++++++++++++++++" 
}

function update_debian() {
  echo "================"
  echo "Updating system"
  if sudo apt update -y && sudo apt upgrade -y; then
    echo "Successfully updated system"
  else
    echo "Error updating the system"
  fi
  echo "Installing python and pip"
  if sudo apt install python3 python3-pip -y; then
    echo "Successfully installed python and pip"
  else
    echo "Error installing python and pip"
  fi
  echo "Installing system dependencies"
  if sudo apt install build-essential libssl-dev libffi-dev python3-dev -y; then
    echo "Successfully installed dependencies"
  else
    echo "Error installing dependencies"
  fi
  if install_pip "${pip[@]}"; then
    echo "Successfully installed all pip packages"
  else
    echo "Pip errors during installation"
  fi
  echo "++++++++++++++++++++"
}

pip=(numpy pandas pillow pip pyarrow matplotlib requests beautifulsoup4 scipy scikit-learn torch scapy cryptography pwntools requests-oauthlib pyOpenSSL paramiko python-nmap impacket dnspython sqlmap-python mechanize shodan virtualenv bandit pyjwt)

echo "=================="
read -p "Is your system Arch or Debian based? [a/D] " -n 1 -r 
echo 
if [[ $REPLY =~ ^[aA]$ ]]; then
  update_arch
elif [[ $REPLY =~ ^[dD]$ ]]; then
  update_debian
else
  echo "Invalid choice. Please run the script again and enter 'a' for Arch-based or 'd' for Debian-based."
  exit 1
fi
echo "===================="
echo "INSTALLATION COMPLETE"
echo "LET'S GET STARTED WITH MACHINE LEARNING!"
echo "+++++++++++++++++++++"
