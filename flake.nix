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

  outputs = inputs@{ self, nixpkgs, nix-darwin, home-manager, ... }:
    let
      mkDarwinHost = {
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
              inherit username gitName gitEmail homeDirectory hostPlatform;
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
                  inherit username gitName gitEmail homeDirectory hostPlatform;
                };
              };
              home-manager.users.${username} = import ./home.nix;
            }
          ];
        };
    in
    {
      # "mac" is the host label. It must match the `#mac` in restart.sh/rebuild.sh.
      darwinConfigurations."mac" = mkDarwinHost {
        hostLabel = "mac";
        username = "stevenegan";
        gitName = "segan2022";
        gitEmail = "steven.egan@ibm.com";
      };
    };
}
