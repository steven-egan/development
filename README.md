# Development Setup

An Apple Silicon macOS development environment managed with Nix, nix-darwin,
Home Manager, and Homebrew. The main tools are Ghostty, herdr, Neovim,
AeroSpace, OpenCode, Raycast, and Hammerspoon.

## First-Time Setup

Clone this repository and create the machine-local configuration before running
the installer:

```sh
git clone <repository-url> development
cd development
cp .env.example .env
# Edit .env for this machine.
./bootstrap.sh
```

`bootstrap.sh` installs Determinate Nix and Homebrew if they are missing,
links the repository to `~/.dotfiles`, and runs the first system switch. It
downloads installer scripts from the internet and may request administrator
access. Check that an existing `~/.dotfiles` points to the intended repository
before running it.

Open a new terminal after setup. Later changes to Nix configuration are applied
from the main repository with:

```sh
./restart.sh
# Or, in a configured shell:
restart
```

The rebuild may update and upgrade Homebrew packages, requests `sudo`, and
attempts to remove the macOS provenance attribute from the repository and
reset ownership of its `.git` directory. Raycast snippet generation runs after
a successful switch; importing the generated file is a separate step.

## Machine Settings

`.env` is ignored by Git and required by `restart.sh`. The individual settings
are optional, but empty or missing values fall back to the defaults in
`flake.nix`, including its existing Git identity. Set them explicitly on a new
machine:

The rebuild sources `.env` as shell code: use trusted content and quote shell
values that contain spaces. It exports the values in a subshell and uses
`sudo -E`, so the privileged rebuild can see them and the inherited environment.
Values used by Nix can also enter the world-readable Nix store. Do not use
these settings for secrets.

Raycast and Hammerspoon read their settings directly as literal `KEY=value`
lines, without shell quoting or expansion. For example, leave
`DOTFILES_GIT_EMAIL` unquoted and use an unquoted path for
`OBSIDIAN_DAILY_NOTE_PATH`; Hammerspoon expands a leading `~/` itself. Reload
Hammerspoon after changing the path. Its shortcuts require macOS Accessibility
permissions, and task capture requires the Obsidian CLI to be enabled.

## Configuration

| Path                                               | Contents                                     | Apply changes                                  |
| -------------------------------------------------- | -------------------------------------------- | ---------------------------------------------- |
| `flake.nix`, `flake.lock`                          | Host definition and locked Nix inputs        | Run `./restart.sh`                             |
| `configuration.nix`                                | macOS settings and Homebrew packages         | Run `./restart.sh`                             |
| `home.nix`                                         | Home Manager packages, Git, shell, and links | Run `./restart.sh`                             |
| `home/herdr/config.toml`                           | herdr configuration                          | Rebuild, then run `herdr server reload-config` |
| `home/nvim/`, `home/ghostty/`, `home/hammerspoon/` | Application configuration                    | Live-linked; reload the application if needed  |
| `home/raycast/`                                    | Snippet template and generator               | Generate and import in Raycast                 |

Most application configs are linked into the home directory through
`~/.dotfiles`; herdr's config is copied through the Nix store instead. The
`dev` shell function searches for repositories under `~/Desktop/repos`.

`flake.lock` pins the Nix inputs and the nix-darwin rebuild package. It does
not pin Homebrew packages or the Nix, Homebrew, and Claude Code installer
scripts. Homebrew is configured to update and upgrade packages during system
activation.

## Daily Workflow

| Command                | Purpose                                               |
| ---------------------- | ----------------------------------------------------- |
| `restart`              | Apply Nix and Home Manager changes                    |
| `dev` or `Ctrl+F`      | Search for a local repository                         |
| `herdr` or `h`         | Start herdr                                           |
| `new-feature <branch>` | Create a worktree and open a spec and agent workspace |

`new-feature` preserves existing `AGENTS.md` and `SPEC.md` files. When no spec
exists, it creates a skeleton and opens it in Neovim. The separate
`ship-feature` and `rm-feature` helpers use forced worktree and branch removal;
check for uncommitted or unmerged work before using them.

herdr's configured prefix is `Ctrl+G`. Use `prefix+?` to inspect keybindings;
`prefix+Alt+G` opens lazygit in a pane.

## Raycast Snippets

Add snippets to `home/raycast/template.json`. Use `${VARIABLE_NAME}` in a
string to insert a literal value from `.env`. Generate the import file with:

```sh
bash home/raycast/generate-snippets.sh
```

In Raycast, run **Import Snippets**, press `Cmd+Shift+G`, and select
`~/.dotfiles/home/raycast/snippets.generated.json`. Review and confirm the
import. Raycast does not automatically sync the file; check for duplicates
before reimporting. The generated file is ignored by Git and may contain
personal values. See `home/raycast/snippets.md` for the template format.

## Troubleshooting

### Validate Nix configuration

```sh
nix flake check --no-build
nix build .#darwinConfigurations.mac.system --dry-run
```

These commands are pure by default and do not read `.env`; they evaluate the
defaults in `flake.nix`. To check machine-specific overrides, export the
relevant variables in your shell and add `--impure`.
