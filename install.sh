#!/bin/bash

# Author: Jaarabytes
# NOTE: This configuration only supports arch linux, nixos and Ubuntu/debian
# I will add support for fedora, if i a second PC.


command_exists() {
    command -v "$1" >/dev/null 2>&1
}

detect_package_manager() {
    if command_exists nix; then
        echo "nix"
    elif command_exists yay; then
        echo "yay"
    elif command_exists pacman; then
        echo "pacman"
    elif command_exists apt; then
        echo "apt"
   else
        echo "unknown"
    fi
}

install_packages() {
    local packages=("$@")
    local package_manager=$(detect_package_manager)

    case $package_manager in
        nix)
            for package in "${packages[@]}"; do
                echo "Installing $package ..."
                if nix-env -iA nixos.$package; then
                    echo "Successfully installed $package"
                else
                    echo "Error installing $package"
                fi
            done
            ;;
        yay)
            for package in "${packages[@]}"; do
                echo "Installing $package ..."
                if yay -S --noconfirm "$package"; then
                    echo "Successfully installed $package"
                else
                    echo "Error installing $package"
                fi
            done
            ;;
        pacman)
            for package in "${packages[@]}"; do
                echo "Installing $package ..."
                if sudo pacman -S --noconfirm "$package"; then
                    echo "Successfully installed $package"
                else
                    echo "Error installing $package"
                fi
            done
            ;;
         apt)
            for package in "${packages[@]}"; do
                echo "Installing $package ..."
                if sudo apt-get install -y "$package"; then
                    echo "Successfully installed $package"
                else
                    echo "Error installing $package"
                fi
            done
            ;;
       *)
            echo "Error: Unsupported package manager. Cannot install packages."
            exit 1
            ;;
    esac
}

copy_configs() {
    local configs=("dunst" "i3" "rofi" "zsh" "polybar" "alacritty" "kitty" "nvim" "fish" "waybar" "hypr" "picom")
    if [ -d ~/.config ]; then
        for config in "${configs[@]}"; do
            if [ -d "$config" ]; then
                echo "Copying $config configuration..."
                cp -r "$config" ~/.config/
            else
                echo "Warning: $config directory not found in the current location."
            fi
        done
        echo "Configurations created."
    else
        echo "Error: ~/.config directory not found."
        exit 1
    fi
}

install_zsh(){
  echo "Installing oh my zsh..."
  if sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"; then
    echo "Installed oh-my-zsh..."
  else
    echo "Failed to installed oh-my-zsh"
  fi

  custom_zshrc="./.zshrc"

  # Check if the custom .zshrc exists
  if [ ! -f "$custom_zshrc" ]; then
    echo "Custom .zshrc file not found!"
  fi

  # Check if the original .zshrc exists in the home directory
  if [ -f "$HOME/.zshrc" ]; then
      echo "Appending custom .zshrc into existing ~/.zshrc..."
      cat "$custom_zshrc" >> "$HOME/.zshrc"
      echo "Appended successfully!"
  else
      echo "No existing .zshrc found. Cloning custom .zshrc to home directory..."
      cp "$custom_zshrc" "$HOME/.zshrc"
      echo "Cloned successfully!"
  fi
}

check_nvim() {
  # Check if nvim is installed
  if ! command_exists nvim ; then
    echo "Neovim is not installed. Installing..."
    if sudo snap install nvim --classic; then
      echo "Neovim installed successfully via snap."
    else
      echo "Failed to install Neovim via snap. Aborting."
      return 1
    fi
  fi

  # Check Neovim version
  nvim_version=$(nvim --version 2>&1 | grep -oE 'v[0-9.]+' | head -n 1) # Extract version
  if [[ -z "$nvim_version" ]]; then
    echo "Could not determine Neovim version. Aborting."
    return 1
  fi

  echo "Neovim version: $nvim_version"

  # Compare versions (using version comparison if available)
  if command -v version >/dev/null 2>&1; then # Check if 'version' command exists
    if version "$nvim_version" ge 0.8; then # Use version command for comparison
      echo "Neovim is version 0.8 or higher. Proceeding..."
    else
      echo "Neovim is less than version 0.8. Upgrading..."
      if sudo snap refresh nvim --classic; then # Attempt upgrade first
        echo "Neovim upgraded successfully via snap."
      else
         echo "Neovim upgrade failed. Removing and reinstalling."
         sudo snap remove nvim
         if sudo snap install nvim --classic; then
            echo "Neovim reinstalled successfully via snap."
         else
            echo "Failed to install Neovim via snap. Aborting."
            return 1
         fi
      fi
    fi
  else # if the version command doesn't exist, fallback to string comparison
    if [[ "$nvim_version" >= "v0.8" ]]; then  # String comparison (less reliable)
      echo "Neovim is version 0.8 or higher. Proceeding..."
    else
      echo "Neovim is less than version 0.8. Upgrading..."
      if sudo snap refresh nvim --classic; then # Attempt upgrade first
        echo "Neovim upgraded successfully via snap."
      else
         echo "Neovim upgrade failed. Removing and reinstalling."
         sudo snap remove nvim
         if sudo snap install nvim --classic; then
            echo "Neovim reinstalled successfully via snap."
         else
            echo "Failed to install Neovim via snap. Aborting."
            return 1
         fi
      fi
    fi
  fi
}


rice() {
    echo "Cloning the repository"
    git clone https://github.com/Jaarabytes/dotfiles.git
    cd dotfiles
    echo "Starting desktop ricing process..."

    # Backup existing configurations
    echo "Backing up existing configurations..."
    backup_dir="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r ~/.config/* "$backup_dir" 2>/dev/null
    if [[ detect_package_manager -eq "nix" ]]; then 
      sudo cp -r /etc/nixos/* "$backup_dir" 2>/dev/null
    fi
    echo "Backup created at $backup_dir"


    packages=("i3" "nodejs" "npm" "snap" "rofi" "fish" "zsh" "polybar" "dunst" "alacritty" "kitty" "maim" "neovim" "swaylock" "jq" "maim" "grim" "hyprland"  "waybar" "swaybg" "wofi" "wlogout" "mako" "thunar" "starship" "swappy" "slurp" "pamixer" "brightnessctl" "gvfs" "bluez" "bluez-utils" "lxappearance" "xdg-desktop-portal-hyprland")
    install_packages "${packages[@]}"
    install_zsh

    copy_configs

    echo "Desktop ricing completed."
    for script in sh/start.sh; do
        if [ -f "$script" ]; then
            echo "Running $script..."
            bash "$script"
        else
            echo "Warning: $script not found."
        fi
    done

    echo "You can start your session using i3 or Hyprland now."
    echo "Rofi should be accessed using super+I or windows-super-key+I"
}

rice

read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebooting..."
    if command_exists systemctl; then
        sudo systemctl reboot
    else
        sudo reboot
    fi
fi
