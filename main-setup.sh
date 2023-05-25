#!/bin/bash

#UPDATE
sudo apt update -y
sudo apt upgrade -y

#SWAP
fallocate -l 4G /swapfile
sudo chmod 600 /swapfile
sudo mkswap /swapfile
sudo swapon /swapfile
sudo swapon --show
free -h
sudo cp /etc/fstab /etc/fstab.bak
echo '/swapfile none swap sw 0 0' | sudo tee -a /etc/fstab
echo "----------------------------------------------------------------"
echo "\nAllocated swap file"
echo "----------------------------------------------------------------"

#GIT
sudo apt install git -y
echo "----------------------------------------------------------------"
echo "\nInstalled Git"
echo "----------------------------------------------------------------"

#GitHub CLI
sudo apt update -y
sudo apt install git -y
git --version
curl -Lso /var/tmp/gh.deb "https://github.com/cli/cli/releases/download/v2.14.6/gh_2.14.6_linux_amd64.deb"
sudo dpkg -i /var/tmp/gh.deb
rm /var/tmp/gh.deb
gh --version
echo "----------------------------------------------------------------"
echo "\nInstalled GitHub CLI"
echo "----------------------------------------------------------------"

#DOCKER
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg
echo "deb [arch=amd64 signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null
sudo apt update
sudo apt install -y docker-ce docker-ce-cli containerd.io
sudo usermod -aG docker $USER
sudo systemctl enable docker
sudo systemctl start docker
echo "----------------------------------------------------------------"
echo "\nInstalled Docker"
echo "----------------------------------------------------------------"

#SERVER-STATUS
wget https://raw.githubusercontent.com/shumilovsergey/bash-scripts/main/server-status.sh && chmod +x server-status.sh && ./server-status.sh

# Clean up
rm ./main-setup.sh
echo "----------------------------------------------------------------"
echo "\nInstallation completed!"
echo "----------------------------------------------------------------"
