{
  description = "Home Manager configuration of epoche";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }: let 
    # set a symbol link
    tools.sym = config: src: 
      config.lib.file.mkOutOfStoreSymlink "${src}";

    # flake path
    tools.flake_path = config: 
      "${config.home.homeDirectory}/home-manager";

    gen_home_conf = { name, system } : 
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./hosts/${name}.nix ];
        extraSpecialArgs = { 
          inherit tools; 
        };
      };
  in {
      homeConfigurations.epoche = 
        gen_home_conf { name = "epoche"; system = "x86_64-darwin"; };
     
      homeConfigurations.suspen = 
        gen_home_conf { name = "suspen"; system = "x86_64-linux"; };
  };
}
