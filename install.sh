#!/usr/bin/env bash

set -e

# Prompt for system information
read -rp "Enter your hostname: " HOSTNAME
read -rp "Enter your username: " USERNAME

echo "▶️ Starting NixOS post-install script..."

# Define user's home directory
USER_HOME="/home/$USERNAME"
REPO="https://github.com/fsuares/dotfiles.git"
DOTFILES_DIR="."

# Copy NixOS system configuration
echo "📁 Copying NixOS system configuration..."
sudo mkdir -p /etc/nixos 
sudo cp -r $DOTFILES_DIR/nixos/* /etc/nixos/

# Copy dotfiles to ~/.config
echo "🛠️ Copying dotfiles to ~/.config..."
sudo mkdir -p "$USER_HOME/.config"
sudo cp -r $DOTFILES_DIR/config/* "$USER_HOME/.config/" 

# Copy home files to ~
echo "📦 Copying additional files to home directory..."
sudo cp -r $DOTFILES_DIR/home/.* "$USER_HOME/"

# Rebuild system with new configuration
echo "🔁 Rebuilding system configuration..."
sudo nixos-rebuild switch 

echo "✅ Setup completed successfully!"
