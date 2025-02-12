#!/bin/bash

# Function to install packages using pacman (Arch-based distros)
function install_pacman_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
    echo "Installing $package..."
    if sudo pacman -S --noconfirm "$package"; then
      echo "Successfully installed $package"
    else
      echo "Error installing $package"
    fi
  done
}

# Function to install packages using apt (Debian-based distros)
function install_apt_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
    echo "Installing $package..."
    if sudo apt install -y "$package"; then
      echo "Successfully installed $package"
    else
      echo "Error installing $package"
    fi
  done
}

# Function to install global npm packages
function install_npm_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
    echo "Installing $package..."
    if sudo npm install -g "$package"; then
      echo "Successfully installed $package"
    else
      echo "Error installing $package"
    fi
  done
}

# Function to install snap packages
# function install_snap_packages() {
#  local packages=("$@")
#  for package in "${packages[@]}"; do
#    echo "Installing $package..."
#    if sudo snap install "$package"; then
#      echo "Successfully installed $package"
#    else
#      echo "Error installing $package"
#    fi
#  done
#}

# Detect the distribution type
if [ -f /etc/os-release ]; then
    . /etc/os-release
    OS=$NAME
else
    echo "Cannot detect the operating system. Exiting."
    exit 1
fi

# Update the system (ask for confirmation)
read -p "Update system first (y/N)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  if [[ $OS == *"Arch"* || $OS == *"Manjaro"* ]]; then
    sudo pacman -Syu --noconfirm && sudo pacman -Sc --noconfirm
    echo "Updated Arch-based system"
  elif [[ $OS == *"Ubuntu"* || $OS == *"Debian"* || $OS == *"Parrot"* ]]; then
    sudo apt update -y && sudo apt upgrade -y
    echo "Updated Debian-based system"
  else
    echo "Unsupported distribution for automatic update. Please update manually."
  fi
fi

# Define package lists
common_packages=(ffmpeg hyfetch ufw tree htop make curl wget grep sed awk git python3-pip alacritty nvtop fish zoxide)
arch_packages=("${common_packages[@]}" yay kubernetes-client eza bat iftop sysstat neovim docker minikube kubectl vagrant screenfetch wf-recorder)
debian_packages=("${common_packages[@]}" snapd kubectl exa batcat iftop sysstat neovim docker.io)
npm_packages=(eslint svelte-language-server typescript pyright ts-node pnpm)
snap_packages=(codium telegram-desktop discord)

# Install packages based on the detected OS
if [[ $OS == *"Arch"* || $OS == *"Manjaro"* ]]; then
  install_pacman_packages "${arch_packages[@]}"
  # Install yay if not present
  if ! command -v yay &> /dev/null; then
    git clone https://aur.archlinux.org/yay.git
    cd yay
    makepkg -si --noconfirm
    cd ..
    rm -rf yay
  fi
  # Use yay to install AUR packages if needed
  # yay -S --noconfirm package_name
elif [[ $OS == *"Ubuntu"* || $OS == *"Debian"* || $OS == *"Linux Mint"* ]]; then
  install_apt_packages "${debian_packages[@]}"
  # Enable snap if it's not already enabled
  sudo systemctl enable --now snapd.socket
else
  echo "Unsupported distribution. Please install packages manually."
  exit 1
fi

# Install npm packages
install_npm_packages "${npm_packages[@]}"

# Install snap packages
install_snap_packages "${snap_packages[@]}"

echo "Installation complete!"
