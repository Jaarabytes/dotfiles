#!/bin/bash

# Author: Jaarabytes
# NOTE: This configuration only supports arch linux or nixos. 
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
        *)
            echo "Error: Unsupported package manager. Cannot install packages."
            exit 1
            ;;
    esac
}

copy_configs() {
    local configs=("dunst" "i3" "rofi" "zsh" "polybar" "alacritty" "kitty" "nvim" "fish" "waybar" "hypr")
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
    echo "Backup created at $backup_dir"

    for script in sh/start.sh sh/machine-learning.sh; do
        if [ -f "$script" ]; then
            echo "Running $script..."
            bash "$script"
        else
            echo "Warning: $script not found."
        fi
    done

    packages=("i3" "rofi" "fish" "zsh" "polybar" "dunst" "alacritty" "kitty" "maim" "neovim" "swaylock" "jq" "maim" "grim" "hyprland"  "waybar" "swaybg" "wofi" "wlogout" "mako" "thunar" "starship" "swappy" "slurp" "pamixer" "brightnessctl" "gvfs" "bluez" "bluez-utils" "lxappearance" "xdg-desktop-portal-hyprland")
    install_packages "${packages[@]}"

    copy_configs

    echo "Desktop ricing completed."
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
