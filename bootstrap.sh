#!/bin/bash
# One-time setup on a fresh (or current) Mac. After this, use ./rebuild.sh.
set -euo pipefail
cd "$(dirname "$0")"

# 1. Determinate Nix
if ! command -v nix &>/dev/null; then
  echo "Installing Determinate Nix..."
  curl --proto '=https' --tlsv1.2 -fsSL https://install.determinate.systems/nix | sh -s -- install --determinate
  # shellcheck disable=SC1091
  . /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.sh
else
  echo "Nix already installed ✅"
fi

# 2. Homebrew (nix-darwin manages the packages, but brew itself must exist)
if ! command -v brew &>/dev/null && [ ! -x /opt/homebrew/bin/brew ]; then
  echo "Installing Homebrew..."
  /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
else
  echo "Homebrew already installed ✅"
fi

# 3. Symlink this repo to ~/.dotfiles (home.nix points at configs through it)
ln -sfn "$PWD" "$HOME/.dotfiles"
echo "Linked $PWD -> ~/.dotfiles ✅"

# 4. First switch (installs darwin-rebuild; later runs use ./rebuild.sh)
echo "Running first darwin-rebuild switch..."
sudo nix run nix-darwin/master#darwin-rebuild -- switch --flake "$HOME/.dotfiles#mac"

echo "✅ Done. Open a new terminal (Ghostty!) and you're on the new setup."
echo "   Daily workflow: edit config -> ./rebuild.sh"
