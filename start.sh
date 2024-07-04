#!/bin/bash

# Function to install packages using apt
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
    if npm install -g "$package"; then
      echo "Successfully installed $package"
    else
      echo "Error installing $package"
    fi
  done
}

# Function to install snap packages
function install_snap_packages() {
  local packages=("$@")
  for package in "${packages[@]}"; do
    echo "Installing $package..."
    if snap install "$package"; then
      echo "Successfully installed $package"
    else
      echo "Error installing $package"
    fi
  done
}

# Update the system (ask for confirmation)
read -p "Update system first (y/N)? " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
  sudo apt update -y && sudo apt upgrade -y
  echo "Updated system"
fi

# Define package lists
apt_packages=(ffmpeg tree eza bat htop iftop iostat netstat make curl wget grep sed awk nvim git docker python3-pip)
npm_packages=(vercel@latest)
snap_packages=(code obsidian slack telegram-desktop discord spotify)

# Install packages
install_apt_packages "${apt_packages[@]}"
install_npm_packages "${npm_packages[@]}"
install_snap_packages "${snap_packages[@]}"

echo "Installation complete!"
