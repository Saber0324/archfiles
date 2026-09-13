#! /usr/bin/env bash

BUILD_DIR=$(mktemp -d)

install_helper() {
  git clone "https://aur.archlinux.org/$1.git" "$BUILD_DIR" || {
    echo "git clone failed "
    return 1
  }

  cd "$BUILD_DIR"

  makepkg -si --noconfirm || {
    echo "makepkg -si failed"
    return 1
  }

  cd -

  rm -rf "$BUILD_DIR"
}

install_dep() {
  sudo pacman -S --needed --noconfirm "$1" || pacman -S --needed --noconfirm "$1"
}

check_dep() {
  if ! command -v git &>/dev/null; then
    echo "git is not installed, installing now..."
    install_dep git
  fi

  if ! pacman -Qi base-devel &>/dev/null; then
    echo "base-devel is not installed, installing now..."
    install_dep base-devel
  fi
}

check_dep

while true; do
  if command -v "paru" &>/dev/null || command -v "yay" &>/dev/null; then
    echo "An AUR helper is already installed, skipping..."
    break
  fi

  read -p "Select an AUR helper to install [yay/paru]: " helper

  if [[ $helper == [Pp]* ]]; then
    install_helper paru
    break

  elif [[ $helper == [Yy]* ]]; then
    install_helper yay
    break

  elif [[ $helper == "exit" || $helper == "quit" ]]; then
    echo "Goodbye!"
    break

  else
    echo "Helper not recognized!"
  fi

done
