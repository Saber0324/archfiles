#!/usr/bin/env bash

set -euo pipefail

if [ ! -d "$HOME/.oh-my-zsh" ]; then
  echo "Installing Oh My Zsh..."
  KEEP_ZSHRC=yes RUNZSH=no CHSH=no \
    sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)" "" --unattended
fi

if [[ "$SHELL" != *"zsh"* ]]; then
  ZSH_PATH="$(command -v zsh || true)"

  if [[ -n "$ZSH_PATH" ]]; then
    echo "Changing default shell to zsh..."
    sudo chsh -s "$ZSH_PATH" "$USER"

  else
    echo "Error: zsh executable not found in PATH." >&2
    exit 1
  fi
fi
