# nix-dotfiles

My Mac, managed with nix-darwin + home-manager. One repo, one command, and a fresh Mac ends up configured the same way every time.

Terminal-first, AI-agent-first: **Ghostty** (terminal) + **herdr** (agent multiplexer, replaces tmux) + Neovim + AeroSpace.

## How it works

How to apply changes:

- **Live-linked config files** (including Ghostty, nvim, AeroSpace, Hammerspoon, and starship) point into `home/`. Edits do not require a rebuild, though applications may need a reload.
- **herdr config** (`home/herdr/config.toml`) is copied into the Nix store by Home Manager. Rebuild after editing it, then reload herdr's config.
- **Nix configuration** (packages, macOS defaults, and Home Manager settings) requires `./restart.sh`.

```
flake.nix          entry point; declares the "mac" machine
configuration.nix  system: macOS defaults, Homebrew apps
home.nix           user: packages, zsh, git, config symlinks
home/              application configs (mostly live-linked into the home directory)
bootstrap.sh       fresh-machine setup (run once)
restart.sh         apply changes (run every time you edit .nix files)
```

## Fresh machine

```sh
git clone <this repo> && cd nix-dotfiles
./bootstrap.sh
```

Installs Determinate Nix + Homebrew if missing, symlinks the repo to `~/.dotfiles`, runs the first switch. Afterward open Ghostty and you're home.

## Daily use

```sh
restart            # alias for ~/.dotfiles/restart.sh — applies .nix changes
dev                # (or ctrl+f) fuzzy-jump to any repo — replaces tmux-sessionizer
herdr              # start the herd
```

### herdr crash course (tmux muscle memory mostly carries over)

Prefix is `ctrl+g`:

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

- **tmux** → herdr. **stow** → home-manager symlinks. Hammerspoon and AeroSpace remain.
- **zsh-autosuggestions / syntax-highlighting brews** → managed by home-manager in `home.nix`.
- **pyenv / python@3.11** → Nix provides Python 3.12; per-project versions belong in a project flake or `poetry env use`.
- **isort / pylint** → per-project dev deps, not global installs.
- **font cask** → MesloLG Nerd Font now comes from nixpkgs (`fonts.packages`).
- **hashicorp vlt** → add back to `brews` in `configuration.nix` if you still use it.

Still here: the ARM toolchain, Bitwarden, Docker CLI, DB Browser, glow, gh, and lazygit (installed through Homebrew or Nix).

Claude Code is installed by a Home Manager activation if it is not already on PATH. Other npm-based tools can be installed under `~/.npm-global`, which is on PATH:

```sh
npm install -g @openai/codex
```

## Validate without applying

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

## Make it not-mine

Create `.env` from `.env.example` before running `./bootstrap.sh` or `./restart.sh`. The scripts source `.env` as shell code, so use only trusted content and quote shell values containing spaces. Raycast and Hammerspoon read their settings as literal text, without quotes or shell expansion. Leave a machine setting empty or omit it to use the defaults in `flake.nix`.

- `DOTFILES_USERNAME` controls both nix-darwin and Home Manager user wiring.
- `DOTFILES_HOME_DIRECTORY` defaults to `/Users/<username>` (override only if needed).
- `DOTFILES_GIT_NAME` / `DOTFILES_GIT_EMAIL` feed Home Manager git config.
- `DOTFILES_HOST_PLATFORM` defaults to `aarch64-darwin`; the rebuild package is currently configured for Apple Silicon.

The rebuild exports `.env` in a subshell and preserves its environment through `sudo`; its values and the inherited environment can be visible to the privileged rebuild. Settings used by Nix can become part of the world-readable Nix store, so do not put secrets in these fields. Direct pure Nix commands, including the validation commands above, ignore `.env` and use the defaults; to validate overrides, export the variables explicitly and add `--impure`. Host label `mac` is fixed in `flake.nix` and the scripts.

Set `OBSIDIAN_DAILY_NOTE_PATH` to the directory containing daily notes (a leading `~/` is expanded). Hammerspoon reads this setting directly from `~/.dotfiles/.env` on config reload, so it works when launched as a GUI app; reload Hammerspoon after changing it. If the entry is absent, it also accepts an inherited environment variable; an empty or missing value uses the existing default in `home/hammerspoon/config.lua`. The repository search root in `home/zsh/zshrc` remains a local assumption and may need adjusting. Hammerspoon requires macOS Accessibility permissions; task capture also requires the Obsidian CLI to be enabled.

Raycast snippets can be generated from `home/raycast/template.json` and imported manually; see `home/raycast/snippets.md` for details. Rebuilds use the nix-darwin version in `flake.lock`, but the Nix, Homebrew, and Claude installers and Homebrew package upgrades remain unpinned.
