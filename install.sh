#!/usr/bin/env bash

set -e

# Prompt for system information
read -rp "Enter your hostname: " HOSTNAME
read -rp "Enter your username: " USERNAME

echo "▶️ Starting NixOS post-install script..."

# Set hostname
echo "📛 Setting hostname to '$HOSTNAME'..."
sudo hostnamectl set-hostname "$HOSTNAME" > /dev/null 2>&1

# Create user if not exists
if ! id "$USERNAME" > /dev/null 2>&1; then
  echo "👤 Creating user '$USERNAME'..."
  sudo useradd -m -G wheel "$USERNAME" > /dev/null 2>&1
  sudo passwd "$USERNAME"
else
  echo "👤 User '$USERNAME' already exists."
fi

# Define user's home directory
USER_HOME="/home/$USERNAME"
REPO="https://github.com/fsuares/dotfiles.git"
DOTFILES_DIR="$HOME/dotfiles"

# Copy repository (dotfiles) to user home
echo "📦 Cloning dotfiles repository to '$USER_HOME/dotfiles'..."
git clone $REPO > /dev/null 2>&1

# Copy NixOS system configuration
echo "📁 Copying NixOS system configuration..."
sudo mkdir -p /etc/nixos > /dev/null 2>&1
sudo cp -r $DOTFILES_DIR/nixos/* /etc/nixos/ > /dev/null 2>&1

# Copy dotfiles to ~/.config
echo "🛠️ Copying dotfiles to ~/.config..."
sudo mkdir -p "$USER_HOME/.config" > /dev/null 2>&1
sudo cp $DOTFILES_DIR/config/* "$USER_HOME/.config/" > /dev/null 2>&1

# Copy home files to ~
echo "📦 Copying additional files to home directory..."
sudo cp -r $DOTFILES_DIR/home/* "$USER_HOME/" > /dev/null 2>&1

# Rebuild system with new configuration
echo "🔁 Rebuilding system configuration..."
sudo nixos-rebuild switch > /dev/null 2>&1

echo "✅ Setup completed successfully!"
