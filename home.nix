# User-level config: packages, shell, git, and dotfile symlinks.
{ config, pkgs, ... }:

let
  # The repo is symlinked to ~/. by bootstrap.sh.
  # Configs under home/ are symlinked into place from there, so editing a
  # file in this repo IS editing your live config — no rebuild needed.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.stateVersion = "26.05";

  ############################################
  # Packages (CLI tools come from Nix now, not brew)
  ############################################
  home.packages = with pkgs; [
    # daily drivers
    neovim
    ripgrep
    fd
    fzf
    jq
    gh
    glow
    lazygit
    gnupg
    rsync
    graphviz

    # languages / runtimes
    nodejs
    go
    python312
  ];

  home.sessionPath = [ "$HOME/.npm-global/bin" ];

  ############################################
  # Shell
  ############################################
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    history = {
      size = 50000;
      ignoreDups = true;
      share = true;
    };

    initContent = "source ~/.dotfiles/home/zsh/zshrc";
  };

  # fzf keybindings: ctrl-r history, ctrl-t files
  programs.fzf.enable = true;

  # Prompt — config lives in home/starship.toml
  programs.starship.enable = true;

  ############################################
  # Git
  ############################################
  programs.git = {
    enable = true;
    settings = {
      user.name = "Steven Egan";
      user.email = "stevenegan10@gmail.com";
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    ignores = [ ".DS_Store" ];
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file.".config/ghostty".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/ghostty";
  home.file.".config/starship.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/starship.toml";
  home.file.".config/nvim".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/nvim";
  home.file.".config/herdr/config.toml".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/herdr/config.toml";
  home.file.".claude/settings.json".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  home.file.".claude/CLAUDE.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".codex/AGENTS.md".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/AGENTS.md";
  home.file.".config/opencode".source =
    config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/opencode";
}
