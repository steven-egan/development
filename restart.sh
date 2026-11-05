#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
USER_HOME="$HOME"
DOTFILES="$USER_HOME/.dotfiles"

# Guard: must be run from the main repo, not a worktree
if git -C "$DIR" rev-parse --git-dir 2>/dev/null | grep -q worktrees; then
  echo "error: run restart.sh from the main repo, not a worktree"
  exit 1
fi

ln -sfn "$DIR" "$DOTFILES"

sudo -H nix \
  --extra-experimental-features 'nix-command flakes' \
  run nix-darwin/master#darwin-rebuild -- \
  switch --flake "$DOTFILES#mac"

sudo xattr -dr com.apple.provenance "$DIR" 2>/dev/null || true
sudo chown -R "$(whoami):staff" "$DIR/.git" 2>/dev/null || true
