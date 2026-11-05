{ config, pkgs, inputs, userConfig, lib, ... }:

let
  # The repo is symlinked to ~/. by bootstrap.sh.
  # Configs under home/ are symlinked into place from there, so editing a
  # file in this repo IS editing your live config — no rebuild needed.
  dotfiles = "${config.home.homeDirectory}/.dotfiles";
in
{
  home.username = userConfig.username;
  home.homeDirectory = userConfig.homeDirectory;
  home.stateVersion = "26.05";

  # Required by modules that integrate with Home Manager accounts.* modules.
  accounts.calendar.basePath = "${userConfig.homeDirectory}/.calendar";
  accounts.contact.basePath = "${userConfig.homeDirectory}/.contacts";

  imports = [ inputs.hunk.homeManagerModules.default ];

  programs.hunk = {
    enable = true;
    enableGitIntegration = true;
  };

  ############################################
  # Packages (CLI tools come from Nix now, not brew)
  ############################################
  home.packages = with pkgs; [
    # daily drivers
    neovim
    tree-sitter # CLI nvim-treesitter's "main" branch shells out to for building parsers
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
    bun
    go
    python312

    # formatters/linters nvim's conform.nvim + nvim-lint shell out to
    stylua
    nixfmt
    nixd # LSP; Mason can't install this one, it has to come from Nix
    ruff
    shfmt
    shellcheck
    golangci-lint
    prettier
    eslint_d
  ];

  home.sessionPath = [
    "$HOME/.local/bin"
    "$HOME/.npm-global/bin"
  ];

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
      user.name = userConfig.gitName;
      user.email = userConfig.gitEmail;
      init.defaultBranch = "main";
      pull.rebase = true;
      push.autoSetupRemote = true;
    };
    ignores = [ ".DS_Store" ];
  };

  # Edit-in-place: the real file stays in my repo, ~/.config just points at it.
  home.file = {
    ".config/ghostty".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/ghostty";
    ".config/starship.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/starship.toml";
    ".config/nvim".source = config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/nvim";
    ".config/herdr/config.toml".source = ./home/herdr/config.toml;
    ".aerospace.toml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/aerospace/aerospace.toml";
    ".hammerspoon".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/hammerspoon";
    "Library/Application Support/lazygit/config.yml".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/lazygit/config.yml";
    ".claude/CLAUDE.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/AGENTS.md";
    ".codex/AGENTS.md".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/AGENTS.md";
    ".config/opencode".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/opencode";
  } // lib.optionalAttrs (builtins.pathExists ./home/.claude/settings.json) {
    ".claude/settings.json".source =
      config.lib.file.mkOutOfStoreSymlink "${dotfiles}/home/.claude/settings.json";
  };

  home.activation.installClaudeCode = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    if ! command -v claude &>/dev/null; then
      export PATH="${pkgs.curl}/bin:${pkgs.perl}/bin:$PATH"
      ${pkgs.curl}/bin/curl -fsSL https://claude.ai/install.sh | bash
    fi
  '';
}
