#! /usr/bin/env bash

BUILD_DIR="$(mktemp -d)"

echo "Installing base packages..."

cp "$HOME/.local/share/chezmoi/packages/PKGBUILD" "$BUILD_DIR" || {
  echo "Error copying to $BUILD_DIR"
  exit 1
}

cd "$BUILD_DIR"

makepkg -si --noconfirm || {
  echo "Error building the packages."
  exit 1
}

cd -
rm -rf "$BUILD_DIR"
