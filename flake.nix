{
  description = "Home Manager configuration of suspen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let
    args = infos@{ username, system }: {
      inherit (nixpkgs) lib;
      inherit infos;
    };

    gen_home_conf = username: system:
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};

        extraSpecialArgs = { 
          ss = import ./ss.nix (args {inherit username system; });
        };

        modules = [ 
          ./hosts/${username}.nix
        ];
     };
  in {
      homeConfigurations.suspen =
        gen_home_conf "suspen" "x86_64-darwin";

      ss = import ./ss.nix (args { username = "ss"; system = "sss"; });
#      homeConfigurations.epoche =
#        gen_home_conf { name = "epoche"; system = "x86_64-linux"; };
  };
}
