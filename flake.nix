{
  description = "Home Manager configuration of suspen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      args = infos@{ username, system }: {
        inherit infos;
        inherit (nixpkgs) lib;
        homecfg = self.outputs.homeConfigurations."${username}".config;
      };

      # home configuration generator function
      home_conf_gen = username: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};

          extraSpecialArgs = {
            ss = import ./libs (args { inherit username system; });
          };

          modules = [
            ./hosts/${username}/home.nix
          ];
        };
    in {
      # My personal macos configuration
      homeConfigurations.suspen =
        home_conf_gen "suspen" "x86_64-darwin";

      # Virtual machine configuration
      homeConfigurations.marisa =
        home_conf_gen "marisa" "x86_64-linux";
    };
}
