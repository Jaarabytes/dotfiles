#!/bin/bash

# This is a script purely for me however you can also copy it
# It setups up my linux machine such that i fully enjoy being a 4x developer

#To be added:
#Add customisables alias to zshconfig, 
#Install forge, foundryup, majority of progrramming languages
#

#Install faster tools eg lazygit, exa, bat/batcat
#More tools to be added


#Check if golang is installed
if command -v go &> /dev/null
then
	echo "Go is installed"
	echo "Proceeding to install tools"
	echo "Installing lazygit"
	git clone https://github.com/jesseduffield/lazygit.git
	cd lazygit
	go install
	echo "Lazygit successfully installed"
	cd ~/
	echo "Installing lazydocker"
	go install github.com/jesseduffield/lazydocker@latest	
	echo "Lazydocker successfully installed"
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
		echo "Succesfully add go binary to your config file, anon"
	elif [[ $choice == "b" ]]; then
		echo ".bashrc is your deafult config file"
		echo "Thank you anon, Proceeding"
		echo 'export PATH=$PATH:/usr/local/go/bin' >> ~/.bashrc
		source ~/.bashrc
	else 
		echo "Invalid choice, choose Z or B"
	echo "Install go and its binaries, we proceed"
