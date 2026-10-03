#!/usr/bin/env bash

set -euo pipefail

if ! command -v git &>/dev/null; then
  echo "Error: git is not installed." >&2
  exit 1
fi

read -p "Do you want to install the Neovim dotfiles? [Y/n]: " nvim_install

if [[ $nvim_install == [Nn]* ]]; then
  echo "Skipping Neovim installation..."
else
  NVIM_DIR="$HOME/.config/nvim"
  if [[ -d "$NVIM_DIR" ]]; then
    echo "Warning: $NVIM_DIR already exists. Skipping clone to avoid overwriting."
  else
    echo "Installing Neovim dotfiles..."
    git clone https://github.com/Saber0324/nvimconf "$NVIM_DIR"
  fi
fi

echo ""

read -p "Do you want to install the Hyprland dotfiles? [Y/n]: " hypr_install

if [[ $hypr_install == [Nn]* ]]; then
  echo "Skipping Hyprland installation..."
else
  HYPR_DIR="$HOME/.config/hypr"
  if [[ -d "$HYPR_DIR" ]]; then
    echo "Warning: $HYPR_DIR already exists. Skipping clone to avoid overwriting."
  else
    echo "Installing Hyprland dotfiles..."
    git clone https://github.com/Saber0324/hypr "$HYPR_DIR"
  fi
fi
