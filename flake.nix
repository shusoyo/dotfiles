{
  description = "Configuration of suspen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nix-darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-darwin, ... }: let
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
          inherit inputs;
        };
      };
  in {
    # My personal macos configuration
    homeConfigurations.suspen = home_conf_gen "suspen" "x86_64-darwin";
    darwinConfigurations."ss" = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ ./hosts/suspen/configuration.nix ];
    };

    # Virtual machine configuration
    homeConfigurations.marisa = home_conf_gen "marisa" "x86_64-linux";
  };
}
