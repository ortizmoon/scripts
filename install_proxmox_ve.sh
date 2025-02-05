#!/bin/bash

set -euo pipefail

# Init env "proxmox_user" from arg
PVE_USERNAME="pveuser" 
PVE_PASS="1234567890"
NODE_NAME="proxmox"
BOOT_DISK="/dev/sda1"

# Noninteractive var
export DEBIAN_FRONTEND=noninteractive

# Set Node name
echo "$NODE_NAME" | sudo tee /etc/hostname > /dev/null
sudo hostnamectl set-hostname "$NODE_NAME"

# Mark bootable disk
echo "grub-pc grub-pc/install_devices_empty boolean false" | sudo debconf-set-selections
echo "grub-pc grub-pc/install_devices string /dev/$BOOT_DISK" | sudo debconf-set-selections
echo "grub-pc grub-pc/bootdev string /dev/$BOOT_DISK" | sudo debconf-set-selections

# Init Debian version
debian_version=$(lsb_release -c | awk '{print $2}')

# Install needed packets
sudo apt update -y && sudo apt install -y wget curl gnupg lsb-release libguestfs-tools

# Add Proxmox repository
echo "deb http://download.proxmox.com/debian/pve $debian_version pve-no-subscription" | sudo tee /etc/apt/sources.list.d/pve-no-subscription.list > /dev/null

# Add key for Proxmox repository
sudo wget https://enterprise.proxmox.com/debian/proxmox-release-"$debian_version".gpg -O /etc/apt/trusted.gpg.d/proxmox-release-"$debian_version".gpg
sudo apt update -y

# Install Proxmox
sudo apt install -y proxmox-ve postfix open-iscsi

# Remove enterprise repo
sudo rm -f /etc/apt/sources.list.d/pve-enterprise.list

# Create PVE user with all privileges
sudo pveum user add "$PVE_USERNAME"@pve -password "$PVE_PASS"
sudo pveum acl modify / -user "$PVE_USERNAME"@pve --roles Administrator

# Create API-token with all privileges
sudo pveum user token add "$PVE_USERNAME"@pve apikey --privsep 0 | sudo tee ~/apikey > /dev/null
sudo chmod 600 ~/apikey