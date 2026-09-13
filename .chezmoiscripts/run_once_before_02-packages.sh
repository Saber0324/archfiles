#! /usr/bin/env bash

BUILD_DIR="$(mktemp -d)"
if command -v paru &>/dev/null; then
  AUR_HELPER="paru"
elif command -v yay &>/dev/null; then
  AUR_HELPER="yay"

echo "Installing base packages..."

cp "$HOME/.local/share/chezmoi/packages/PKGBUILD" "$BUILD_DIR" || {
  echo "Error copying to $BUILD_DIR"
  exit 1
}

cd "$BUILD_DIR"

"$AUR_HELPER" -Bi --noconfirm || {
  echo "Error building the packages."
  exit 1
}

cd -
rm -rf "$BUILD_DIR"
