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
    special-args-gen = username: system: {
      inherit inputs;
      ss = import ./lib {
        inherit username system self;
        inherit (nixpkgs) lib;
      };
    };

    # home configuration generator
    home-conf-gen = hostname: username: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        extraSpecialArgs = special-args-gen username system;
        modules = [
          ./hosts/${hostname}/home.nix
        ];
      };
  in {
    # My personal macos configuration
    homeConfigurations.suspen = home-conf-gen "ss" "suspen" "x86_64-darwin";
    darwinConfigurations.ss = nix-darwin.lib.darwinSystem {
      system = "x86_64-darwin";
      modules = [
        ./hosts/ss/configuration.nix
      ];
    };

    # Linux
    homeConfigurations.sl = home-conf-gen "camel" "sl" "x86_64-linux";
    homeConfigurations.mirage = home-conf-gen "camel" "mirage" "x86_64-linux";
    nixosConfigurations.camel = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [
        ./hosts/camel/configuration.nix
      ];
    };
  };
}
