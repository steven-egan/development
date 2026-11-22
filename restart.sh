#!/usr/bin/env bash
set -euo pipefail

DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd -P)"
USER_HOME="$HOME"
DOTFILES="$USER_HOME/.dotfiles"

if [[ ! -f "$DIR/.env" ]]; then
  echo "error: $DIR/.env is missing; create it from .env.example" >&2
  exit 1
fi
# Guard: must be run from the main repo, not a worktree
if git -C "$DIR" rev-parse --git-dir 2>/dev/null | grep -q worktrees; then
  echo "error: run restart.sh from the main repo, not a worktree"
  exit 1
fi

ln -sfn "$DIR" "$DOTFILES"

(
  set -a
  # shellcheck source=/dev/null
  source "$DIR/.env"
  set +a
  sudo -H -E nix \
    --extra-experimental-features 'nix-command flakes' \
    run "$DOTFILES#darwin-rebuild" -- \
    switch --impure --flake "$DOTFILES#mac"
)

sudo xattr -dr com.apple.provenance "$DIR" 2>/dev/null || true
sudo chown -R "$(whoami):staff" "$DIR/.git" 2>/dev/null || true

if ! bash "$DIR/home/raycast/generate-snippets.sh"; then
  echo "Raycast snippets could not be generated; see home/raycast/snippets.md."
fi
