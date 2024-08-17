#!/bin/bash

# Improved desktop ricing script

# Function to check if a command exists
command_exists() {
    command -v "$1" >/dev/null 2>&1
}

# Function to install packages
install_packages() {
    local packages=("$@")
    for package in "${packages[@]}"; do
        echo "Installing $package ..."
        if command_exists yay; then
            if yay -S --noconfirm "$package"; then
                echo "Successfully installed $package"
            else
                echo "Error installing $package"
            fi
        elif command_exists pacman; then
            if sudo pacman -S --noconfirm "$package"; then
                echo "Successfully installed $package"
            else
                echo "Error installing $package"
            fi
        else
            echo "Error: Neither yay nor pacman found. Cannot install packages."
            exit 1
        fi
    done
}

# Function to copy configurations
copy_configs() {
    local configs=("dunst" "i3" "rofi" "zsh" "polybar" "alacritty" "kitty" "maim" "nvim")
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

# Main function
rice() {
    echo "Starting desktop ricing process..."

    # Backup existing configurations
    echo "Backing up existing configurations..."
    backup_dir="$HOME/config_backup_$(date +%Y%m%d_%H%M%S)"
    mkdir -p "$backup_dir"
    cp -r ~/.config/* "$backup_dir" 2>/dev/null
    echo "Backup created at $backup_dir"

    # Run additional scripts if they exist
    for script in sh/start.sh sh/machine-learning.sh; do
        if [ -f "$script" ]; then
            echo "Running $script..."
            bash "$script"
        else
            echo "Warning: $script not found."
        fi
    done

    # Install packages
    packages=("i3" "rofi" "fish" "zsh" "polybar" "dunst" "alacritty" "kitty" "maim" "neovim" "swaylock" "jq")
    install_packages "${packages[@]}"

    # Copy configurations
    copy_configs

    echo "Desktop ricing completed."
    echo "You can start your session using i3 now."
    echo "Rofi should be accessed using super+I or windows-super-key+I"
}

# Run the main function
rice

# Prompt for reboot
read -p "Do you want to reboot now? (y/n) " -n 1 -r
echo
if [[ $REPLY =~ ^[Yy]$ ]]; then
    echo "Rebooting..."
    sudo reboot
fi
