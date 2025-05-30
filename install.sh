#!/bin/bash

# Define paths
NVIM_CONFIG="$HOME/.config/nvim"
NVIM_BACKUP="$HOME/.config/nvim_old"
SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
NEW_NVIM_DIR="$SCRIPT_DIR/nvim"

# Backup existing Neovim config if it exists
if [ -d "$NVIM_CONFIG" ]; then
    echo "Backing up existing neovim config to $NVIM_BACKUP..."
    rm -rf "$NVIM_BACKUP"
    mv "$NVIM_CONFIG" "$NVIM_BACKUP"
fi

# Copy new config
echo "Copying new neovim config from $NEW_NVIM_DIR to $NVIM_CONFIG..."
cp -r "$NEW_NVIM_DIR" "$NVIM_CONFIG"

echo "Done!"

