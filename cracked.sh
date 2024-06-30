#!/bin/bash

# This is a script purely for me however you can also copy it
# It setups up my linux machine such that i fully enjoy being a 4x developer

#To be added:
#Add customisables alias to zshconfig, 
#Install forge, foundryup, majority of progrramming languages
#

#Install faster tools eg lazygit, exa, bat/batcat
#More tools to be added
echo "BEWARE!!!!!!!!!"
echo "This script installs cracked engineering tools such as lazygit, lazydocker, neovim, exa, ripgrep, bat/batcat"
echo "I prefer if your system was debian based, obviously not using Ubuntu (that's just a toy Linux distribution)"
echo "                      "
read -p "Do you wish to continue?" choice
if [[ $choice == 'y' ]]
    echo "LETSSS GOOOOOOOOOOOOOOOOOOOOOOO"

    # System updates first, everything is to be updated
    echo "Updating system first"
    sudo apt update -y && sudo apt upgrade -y && sudo apt autoremove -y
    echo "System successfully updated"
    # Installing neovim
    echo "Installing neovim,"
    sudo apt install neovim
    echo "Neovim installed"

    echo "Installing bat/batcat"
    sudo apt install bat
    echo "Bat/batcat successfully installed"

    echo "Installing exa / eza"
    sudo apt install eza
    echo "Exa/eza successfully installed"

    #Check if golang is installed
    # Lazygit and lazydocker depend on golang being installed on the system.
    if command -v go &> /dev/null
    then
        echo "Go is installed"
        echo "Proceeding to install tools"
        # check if git is installed
        echo 'Checking if git is installed'
        if command -v git >/dev/null 2>&1; then
            sudo apt install git
            echo "Succesfully installed git" 
            echo "Installing lazygit"
            git clone https://github.com/jesseduffield/lazygit.git
            cd lazygit
            go install
            echo "Lazygit successfully installed"
        else
            echo "Installing lazygit"
            git clone https://github.com/jesseduffield/lazygit.git
            cd lazygit
            go install
            echo "Lazygit successfully installed"
        fi
               # check if docker is installed
        if command -v docker >/dev/null 2>&1; then
            sudo apt install docker
            echo "Succesfully installed docker" 
            echo "Installing lazydocker"
            go install github.com/jesseduffield/lazydocker@latest	
        else
            echo "Installing lazydocker"
            go install github.com/jesseduffield/lazydocker@latest	
            echo "Lazydocker successfully installed"
        fi
    else 
        echo "Go is not installed yet"
        echo "Installing golang"
        sudo apt update
        wget https://golang.org/dl/go1.20.6.linux-amd64.tar.gz
        sudo rm -rf /usr/local/go
        sudo tar -C /usr/local -xzf go1.20.6.linux-amd64.tar.gz
        read -p "What is you default config file? Z(zshrc) or B (bashrc)" choice
        if [[ $choice == "z" ]]; then
            echo ".zshrc is your default config file"
            echo "Thank you anon, Proceeding"
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.zshrc
            source ~/.zshrc
            echo "Succesfully added go binary to your config file, anon"
        elif [[ $choice == "b" ]]; then
            echo ".bashrc is your default config file"
            echo "Thank you anon, Proceeding"
            echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
            source ~/.bashrc
        else 
            echo "Invalid choice, choose Z or B"
        fi
        echo "Install go and its binaries, we proceed"
        sudo apt update -y && sudo apt upgrade -y
        # add your nvim configurations.
        # And shortcuts such as lzg and lzd
    fi
elif [[ choice == 'n' ]]
    echo 'WEAKKK!!!!!!!!!!!!!!'
else 
    echo "Wrong choice buddy!"
    exit 0
fi
