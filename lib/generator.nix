inputs@{ self, nixpkgs, home-manager, darwin, ... }:

rec {
  special-args-gen = username: system: hostname: {
    inherit inputs;
    ss = import ./default.nix {
      inherit username system hostname self;
      inherit (nixpkgs) lib;
    };
  };

  # home configuration generator
  home-conf-gen = hostname: username: system: {
    homeConfigurations."${username}" = home-manager.lib.homeManagerConfiguration {
      pkgs = nixpkgs.legacyPackages.${system};
      extraSpecialArgs =
        special-args-gen username system hostname;
      modules = [
        ../hosts/${hostname}/home.nix
      ];
    };
  };

  sys-conf-gen = id: f: hostname: username: system: {
    "${id}"."${hostname}" = f {
      inherit system;
      specialArgs = special-args-gen username system hostname;
      modules = [
        ../hosts/${hostname}/system.nix
      ];
    };
  };

  macos-conf-gen = sys-conf-gen
    "darwinConfigurations" darwin.lib.darwinSystem
  ;
  nixos-conf-gen = sys-conf-gen
    "nixosConfigurations"  nixpkgs.lib.nixosSystem
  ;
  merge-conf = nixpkgs.lib.attrsets.foldAttrs
    (x: acc: nixpkgs.lib.recursiveUpdate x acc) {}
  ;
}
