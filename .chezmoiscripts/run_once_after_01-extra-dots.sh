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
  proceed=true

  if [[ -d "$NVIM_DIR" ]]; then
    read -p "Directory $NVIM_DIR already exists. Delete and replace it? [y/N]: " delete_nvim
    if [[ $delete_nvim == [Yy]* ]]; then
      echo "Removing existing directory..."
      rm -rf "$NVIM_DIR"
    else
      echo "Skipping Neovim installation to preserve existing files."
      proceed=false
    fi
  fi

  if [[ $proceed == true ]]; then
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
  proceed=true

  if [[ -d "$HYPR_DIR" ]]; then
    read -p "Directory $HYPR_DIR already exists. Delete and replace it? [y/N]: " delete_hypr
    if [[ $delete_hypr == [Yy]* ]]; then
      echo "Removing existing directory..."
      rm -rf "$HYPR_DIR"
    else
      echo "Skipping Hyprland installation to preserve existing files."
      proceed=false
    fi
  fi

  if [[ $proceed == true ]]; then
    echo "Installing Hyprland dotfiles..."
    git clone https://github.com/Saber0324/hypr "$HYPR_DIR"
  fi
fi
