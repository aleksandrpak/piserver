#!/bin/sh

# Prepare installation
sudo apt update

# Install Git
sudo apt install git

# Install Wake On Lan
sudo apt-get install etherwake

# Install Github
curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | sudo dd of=/usr/share/keyrings/githubcli-archive-keyring.gpg \
&& sudo chmod go+r /usr/share/keyrings/githubcli-archive-keyring.gpg \
&& echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | sudo tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
&& sudo apt update \
&& sudo apt install gh -y
gh auth login

# Get the repo
cd ~
gh repo clone aleksandrpak/piserver

# Install Tailscale
sudo apt-get install apt-transport-https
curl -fsSL https://pkgs.tailscale.com/stable/raspbian/buster.gpg | sudo apt-key add -
curl -fsSL https://pkgs.tailscale.com/stable/raspbian/buster.list | sudo tee /etc/apt/sources.list.d/tailscale.list
sudo apt-get update
sudo apt-get install tailscale
sudo tailscale up --advertise-exit-node --accept-dns=false

# Create mount folder and mount it on boot
mkdir -p /mnt/usb/drive
echo "/dev/sda1 /mnt/usb/media exfat nofail,uid=1000,gid=1000 0 0" | sudo tee -a /etc/fstab

# Create docker config folders
mkdir -p ~/docker/pihole
mkdir -p ~/docker/nzbget
mkdir -p ~/docker/sonarr
mkdir -p ~/docker/radarr
mkdir -p ~/docker/jellyfin

# Install Docker
curl -fsSL https://get.docker.com -o install-docker.sh
sudo sh install-docker.sh
sudo usermod -aG docker ${USER}
echo "Logout now to finish docker installation"
