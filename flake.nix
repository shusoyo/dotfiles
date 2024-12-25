{
  description = "Home Manager configuration of suspen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, home-manager, ... }:
    let
      args = info@{ username, system }: {
        inherit info self;
        inherit (nixpkgs) lib;
      };

      # home configuration generator
      home_conf_gen = username: system:
        home-manager.lib.homeManagerConfiguration {
          pkgs = nixpkgs.legacyPackages.${system};
          modules = [ ./hosts/${username}/home.nix ];

          extraSpecialArgs = {
            ss = import ./lib (args { inherit username system; });
          };
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
