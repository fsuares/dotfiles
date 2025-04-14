#!/usr/bin/env bash

set -e

# Prompt for system information
read -rp "Enter your hostname: " HOSTNAME
read -rp "Enter your username: " USERNAME

echo "▶️ Starting NixOS post-install script..."

echo "✅ Home Manager and nixos-hardware channels have been added."
sudo nix-channel --add https://github.com/nix-community/home-manager/archive/release-24.11.tar.gz home-manager
sudo nix-channel --add https://github.com/NixOS/nixos-hardware/archive/master.tar.gz nixos-hardware
sudo nix-channel --update
echo "🔄 Channels have been updated."

# Define user's home directory
USER_HOME="/home/$USERNAME"
REPO="https://github.com/fsuares/dotfiles.git"
DOTFILES_DIR="."

# Copy NixOS system configuration
echo "📁 Copying NixOS system configuration..."
sudo mkdir -p /etc/nixos
sudo cp -r $DOTFILES_DIR/nixos/* /etc/nixos/
echo "✅ Copied!"

# Copy dotfiles to ~/.config
echo "🛠️ Copying dotfiles to ~/.config..."
sudo mkdir -p "$USER_HOME/.config"
sudo cp -r $DOTFILES_DIR/config/* "$USER_HOME/.config/"
echo "✅ Copied!"

# Copy home files to ~
echo "📦 Copying additional files to home directory..."
sudo cp -r $DOTFILES_DIR/home/.* "$USER_HOME/"
echo "✅ Copied!"

# Rebuild system with new configuration
echo "🔁 Rebuilding system configuration..."
sudo nixos-rebuild switch

echo "✅ Setup completed successfully!"
