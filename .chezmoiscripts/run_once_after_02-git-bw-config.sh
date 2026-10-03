#!/usr/bin/env bash
set -euo pipefail

GIT_NAME="Saber"
GIT_EMAIL="250929174+Saber0324@users.noreply.github.com"

BW_ITEMS=("github" "AUR")
PRIMARY_KEY_ITEM="github"

ALLOWED_SIGNERS_FILE="$HOME/.ssh/allowed_signers"
BW_SOCKET="$HOME/.bitwarden-ssh-agent.sock"

read -p "Do you want to set up Git SSH signing with Bitwarden? [y/N]: " signing_install

if [[ $signing_install != [Yy]* ]]; then
  echo "Skipping Git signing setup..."
  exit 0
fi

export SSH_AUTH_SOCK="$BW_SOCKET"

ERR_FILE="$(mktemp)"
trap 'rm -f "$ERR_FILE"' EXIT

echo "Fetching SSH Keys from Bitwarden"

if [[ -z "${BW_SESSION:-}" ]]; then
  echo "Unlocking Bitwarden vault..."
  BW_SESSION="$(bw unlock --raw)"
  export BW_SESSION
fi

mkdir -p "$HOME/.ssh"
chmod 700 "$HOME/.ssh"
touch "$ALLOWED_SIGNERS_FILE"
chmod 600 "$ALLOWED_SIGNERS_FILE"

PRIMARY_PUB_KEY=""

for ITEM_NAME in "${BW_ITEMS[@]}"; do
  if ! ITEM_JSON="$(bw get item "$ITEM_NAME" 2>"$ERR_FILE")"; then
    echo "Failed to fetch '$ITEM_NAME' from Bitwarden: $(<"$ERR_FILE")"
    continue
  fi

  RAW_PUB_KEY="$(jq -r '.sshKey.publicKey // empty' <<<"$ITEM_JSON" 2>/dev/null | head -n1 | tr -d '\r' || true)"

  if [[ "$RAW_PUB_KEY" =~ ^(ssh-|sk-) ]]; then
    PUB_KEY="$(awk '{print $1" "$2}' <<<"$RAW_PUB_KEY")"
    SIGNER_ENTRY="$GIT_EMAIL $PUB_KEY"

    if grep -qxF -- "$SIGNER_ENTRY" "$ALLOWED_SIGNERS_FILE"; then
      echo " Key '$ITEM_NAME' already present in $ALLOWED_SIGNERS_FILE"
    else
      echo "$SIGNER_ENTRY" >>"$ALLOWED_SIGNERS_FILE"
      echo " Added '$ITEM_NAME' public key to $ALLOWED_SIGNERS_FILE"
    fi

    if [[ "$ITEM_NAME" == "$PRIMARY_KEY_ITEM" ]]; then
      PRIMARY_PUB_KEY="$PUB_KEY"
    fi
  else
    echo "Item '$ITEM_NAME' has no valid SSH public key in .sshKey.publicKey (must start with ssh- or sk-)."
  fi
done

if [[ -n "$PRIMARY_PUB_KEY" ]]; then
  echo ""
  echo "Configuring Git global settings..."
  git config --global user.name "$GIT_NAME"
  git config --global user.email "$GIT_EMAIL"
  git config --global init.defaultBranch main

  git config --global gpg.format ssh
  git config --global gpg.ssh.program ssh-keygen
  git config --global user.signingkey "key::$PRIMARY_PUB_KEY"
  git config --global commit.gpgsign true
  git config --global tag.gpgSign true
  git config --global gpg.ssh.allowedSignersFile "$ALLOWED_SIGNERS_FILE"

  echo "Global Git signing set to '$PRIMARY_KEY_ITEM'."

  BASE64_KEY="${PRIMARY_PUB_KEY#* }"
  if [[ -S "$BW_SOCKET" ]] && ! ssh-add -L 2>/dev/null | grep -qF -- "$BASE64_KEY"; then
    echo ""
    echo "Primary key not currently exposed by the SSH agent."
    echo "Verify that the key is in your vault and Bitwarden Desktop is unlocked."
  fi
fi

for SHELL_RC in "$HOME/.bashrc" "$HOME/.zshrc"; do
  if [[ -f "$SHELL_RC" ]] && ! grep -q "bitwarden-ssh-agent.sock" "$SHELL_RC"; then
    printf '\n# Bitwarden SSH Agent\nexport SSH_AUTH_SOCK="%s"\n' "$BW_SOCKET" >>"$SHELL_RC"
    echo "Added SSH_AUTH_SOCK export to $SHELL_RC"
  fi
done

if [[ ! -S "$BW_SOCKET" ]]; then
  echo ""
  echo "$BW_SOCKET socket not found."
  echo "Ensure Bitwarden Desktop is running and unlocked for signing to function."
fi

echo ""
echo "Setup complete!"
