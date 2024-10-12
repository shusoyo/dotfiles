{
  description = "Home Manager configuration of epoche";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { self, nixpkgs, home-manager, ... }: let 
    config = self.outputs.homeConfigurations;
    
    tools = cfg: {
      flakePath = 
        "${cfg.home.homeDirectory}/home-manager";
      
      symlink = src: 
        cfg.lib.file.mkOutOfStoreSymlink "${src}";
    };

    gen_home_conf = { name, system } : 
      home-manager.lib.homeManagerConfiguration {
        pkgs = nixpkgs.legacyPackages.${system};
        modules = [ ./users/${name}.nix ];
        extraSpecialArgs = { 
          tools = tools config.${name}.config;     
        }; 
      };
  in {
      homeConfigurations.epoche = 
        gen_home_conf { name = "epoche"; system = "x86_64-darwin"; };
     
      homeConfigurations.suspen = 
        gen_home_conf { name = "suspen"; system = "x86_64-linux"; };
  };
}
