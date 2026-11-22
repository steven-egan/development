{
  description = "Egan's Mac — one repo, one command, same machine every time";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

    nix-darwin = {
      url = "github:nix-darwin/nix-darwin/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    hunk = {
      url = "github:modem-dev/hunk";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nix-darwin,
      home-manager,
      ...
    }:
    let
      envOr = name: fallback:
        let value = builtins.getEnv name;
        in if value == "" then fallback else value;
      mkDarwinHost =
        {
          hostLabel,
          username,
          gitName,
          gitEmail,
          homeDirectory ? "/Users/${username}",
          hostPlatform ? "aarch64-darwin",
        }:
        nix-darwin.lib.darwinSystem {
          specialArgs = {
            inherit inputs;
            userConfig = {
              inherit
                username
                gitName
                gitEmail
                homeDirectory
                hostPlatform
                ;
            };
          };

          modules = [
            ./configuration.nix
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;
              home-manager.backupFileExtension = "hm-backup";
              home-manager.sharedModules = [
                {
                  accounts.calendar.basePath = "${homeDirectory}/.calendar";
                  accounts.contact.basePath = "${homeDirectory}/.contacts";
                }
              ];
              home-manager.extraSpecialArgs = {
                inherit inputs;
                userConfig = {
                  inherit
                    username
                    gitName
                    gitEmail
                    homeDirectory
                    hostPlatform
                    ;
                };
              };
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };
    in
    {
      packages.aarch64-darwin.darwin-rebuild = nix-darwin.packages.aarch64-darwin.darwin-rebuild;

      # "mac" is the host label. It must match the `#mac` in restart.sh.
      darwinConfigurations."mac" = mkDarwinHost {
        hostLabel = "mac";
        username = envOr "DOTFILES_USERNAME" "egan";
        gitName = envOr "DOTFILES_GIT_NAME" "steven-egan";
        gitEmail = envOr "DOTFILES_GIT_EMAIL" "stevenegan10@gmail.com";
        homeDirectory = envOr "DOTFILES_HOME_DIRECTORY" "/Users/${envOr "DOTFILES_USERNAME" "egan"}";
        hostPlatform = envOr "DOTFILES_HOST_PLATFORM" "aarch64-darwin";
      };
    };
}
