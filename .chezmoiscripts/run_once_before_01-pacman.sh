#! /usr/bin/env bash

SRC="$HOME/.local/share/chezmoi/packages/pacman.conf"
DEST="/etc/pacman.conf"

if [[ -f "$DEST" ]] && [[ "$(realpath "$SRC")" == "$(realpath "$DEST")" ]]; then
  echo "Source and destination are the same file, nothing to do."

else
  if [[ ! -f "$SRC" ]]; then
    echo "Source file not found: $SRC"
    exit 1
  fi

  if [[ -f "$DEST" ]]; then
    sudo cp "$DEST" "$DEST.bak"
  fi

  sudo cp "$SRC" "$DEST" || {
    echo "Failed to copy pacman.conf"
    exit 1
  }

  echo "pacman.conf installed. Backup saved at $DEST.bak (if one existed)."
fi

# Install CachyOS repos, if not already installed
if pacman -Qi cachyos-keyring &>/dev/null && [[ -f /etc/pacman.d/cachyos-mirrorlist ]]; then
  echo "CachyOS repos already installed, skipping."

else
  echo "Installing CachyOS repositories..."

  BUILD_DIR="$(mktemp -d)"
  cd "$BUILD_DIR" || exit 1

  curl -O https://mirror.cachyos.org/cachyos-repo.tar.xz || {
    echo "Download failed"
    exit 1
  }

  tar xf cachyos-repo.tar.xz || {
    echo "Extraction failed"
    exit 1
  }

  cd cachyos-repo || exit 1

  sudo ./cachyos-repo.sh || {
    echo "CachyOS repo script failed"
    exit 1
  }

  cd -
  rm -rf "$BUILD_DIR"
  echo "CachyOS repos installed successfully"
fi
