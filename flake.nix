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
    special-args-gen = info@{ username, system }: {
      inherit inputs;
      ss = import ./lib ({
        inherit info self;
        inherit (nixpkgs) lib;
      });
    };

    # home configuration generator
    home-conf-gen = username: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./hosts/${username}/home.nix ];
        extraSpecialArgs = special-args-gen { inherit username system; };
      };
  in {
    # My personal macos configuration
    homeConfigurations.suspen = home-conf-gen "suspen" "x86_64-darwin";
    darwinConfigurations.ss = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [ ./hosts/suspen/configuration.nix ];
    };

    # Linux
    homeConfigurations.sl = home-conf-gen "sl" "x86_64-linux";
    nixosConfigurations.nixos = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ ./hosts/sl/configuration.nix ];
    };
  };
}
