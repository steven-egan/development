# System-level config: macOS defaults + Homebrew.
# User-level things (shell, packages, dotfile symlinks) live in home.nix.
{ pkgs, ... }:

{
  # Determinate Nix manages the nix daemon itself; nix-darwin must not touch it.
  nix.enable = false;

  nixpkgs.hostPlatform = "aarch64-darwin";

  system.stateVersion = 6;
  system.primaryUser = "egan";

  users.users.egan = {
    name = "egan";
    home = "/Users/egan";
  };

  # zsh as the shell; nix-darwin wires the Nix env into it.
  programs.zsh.enable = true;

  # Touch ID for sudo.
  security.pam.services.sudo_local.touchIdAuth = true;

  # Remap Caps Lock to Escape.
  system.keyboard = {
    enableKeyMapping = true;
    remapCapsLockToEscape = true;
  };

  # Fonts installed system-wide from nixpkgs (replaces the old font cask).
  fonts.packages = [ pkgs.nerd-fonts.meslo-lg ];

  ############################################
  # macOS defaults — applied on every rebuild
  ############################################
  system.defaults = {
    NSGlobalDomain = {
      AppleInterfaceStyle = "Dark";
      AppleShowAllExtensions = true;
      InitialKeyRepeat = 15; # shorter delay before repeat
      KeyRepeat = 2;         # faster repeat
      NSAutomaticSpellingCorrectionEnabled = false;
    };
    dock = {
      autohide = true;
      show-recents = false;
      mru-spaces = false; # don't reorder spaces — keeps AeroSpace predictable
    };
    finder = {
      ShowPathbar = true;
      FXPreferredViewStyle = "clmv"; # column view
      FXEnableExtensionChangeWarning = false;
    };
    trackpad.Clicking = true; # tap to click
  };

  ############################################
  # Homebrew — declarative
  #
  # cleanup = "zap": every rebuild REMOVES any brew package/cask on this
  # machine that isn't listed below. Fully declarative, but add anything
  # you want to keep BEFORE the first switch.
  ############################################
  homebrew = {
    enable = true;
    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "nikitabobko/tap"      # aerospace
      "zegervdv/zathura"     # pdf viewer
      "osx-cross/arm"
      "osx-cross/avr"
      "armmbed/formulae"
    ];

    brews = [
      "herdr"      # agent multiplexer (replaces tmux)
      "docker"     # docker CLI
      "luarocks"   # lazy.nvim wants it
      "armmbed/formulae/arm-none-eabi-gcc"
      "anomalyco/tap/opencode"
    ];

    casks = [
      "ghostty"                  # terminal (replaces old terminal setup)
      "nikitabobko/tap/aerospace" # tiling window manager
      "bitwarden"
      "db-browser-for-sqlite"
      "raycast"
      "zen"
      "google-chrome"
      "obsidian"
    ];
  };
}
