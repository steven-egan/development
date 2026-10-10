# nix-dotfiles

My Mac, managed with nix-darwin + home-manager. One repo, one command, and a fresh Mac ends up configured the same way every time.

Terminal-first, AI-agent-first: **Ghostty** (terminal) + **herdr** (agent multiplexer, replaces tmux) + Neovim + AeroSpace.

## How it works

Two kinds of change, two speeds:

- **Config files** (`home/` — Ghostty, herdr, nvim, aerospace, starship) are symlinked into place. Edit them here and the change is live immediately. No rebuild.
- **Everything else** (packages, macOS defaults, aliases in `home.nix`) — edit, then run `./rebuild.sh`.

```
flake.nix          entry point; declares the "mac" machine
configuration.nix  system: macOS defaults, Homebrew apps
home.nix           user: packages, zsh, git, config symlinks
home/              live-editable configs (symlinked to ~/.config/*)
bootstrap.sh       fresh-machine setup (run once)
rebuild.sh         apply changes (run every time you edit .nix files)
```

## Fresh machine

```sh
git clone <this repo> && cd nix-dotfiles
./bootstrap.sh
```

Installs Determinate Nix + Homebrew if missing, symlinks the repo to `~/.dotfiles`, runs the first switch. Afterward open Ghostty and you're home.

## Daily use

```sh
rebuild            # alias for ./rebuild.sh — applies .nix changes
dev                # (or ctrl+f) fuzzy-jump to any repo — replaces tmux-sessionizer
herdr              # start the herd
```

### herdr crash course (tmux muscle memory mostly carries over)

Prefix is `ctrl+b`:

| Keys | Action |
|---|---|
| `prefix c` / `n` / `p` | new / next / prev tab |
| `prefix v` / `prefix -` | split vertical / horizontal |
| `prefix h j k l` | focus pane |
| `prefix z` | zoom pane |
| `prefix w` | workspace picker |
| `prefix q` | detach — agents keep running |
| `prefix alt+g` | lazygit pane (custom, in `home/herdr/config.toml`) |
| `prefix ?` | help |

Sessions survive closing Ghostty. `herdr` reattaches. Works over SSH from a phone too.

## Migration notes (vs the old dot_files setup)

Dropped, on purpose:

- **tmux** → herdr. **stow** → home-manager symlinks. **hammerspoon** → gone (AeroSpace stays).
- **zsh-autosuggestions / syntax-highlighting brews** → managed by home-manager in `home.nix`.
- **pyenv / python@3.11** → Nix provides Python 3.12; per-project versions belong in a project flake or `poetry env use`.
- **isort / pylint** → per-project dev deps, not global installs.
- **font cask** → MesloLG Nerd Font now comes from nixpkgs (`fonts.packages`).
- **hashicorp vlt** → add back to `brews` in `configuration.nix` if you still use it.

Still here: oolchain, zathura, bitwarden, docker CLI, db-browser, deno/glow/gh/lazygit/etc. (now via Nix).

AI agents (claude-code, codex, etc.): install via npm as before — `~/.npm-global` is already on PATH:

```sh
npm install -g @anthropic-ai/claude-code
```

## Validate without applying

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

## Make it not-mine

Username/home path: `flake.nix` (`home-manager.users.egan`), `configuration.nix` (`primaryUser`, `users.users`), `home.nix` (git identity). Host label `mac`: `flake.nix` + both scripts. Intel Mac: `hostPlatform = "x86_64-darwin"` in `configuration.nix`.
