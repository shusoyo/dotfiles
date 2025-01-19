{ inputs, config, lib, ss, ... }:

let
  cfg = config.modules.home-manager;
in {
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.modules.home-manager = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    home-manager = {
      useGlobalPkgs       = true;
      useUserPackages     = true;
      extraSpecialArgs    = { inherit ss inputs; };
      backupFileExtension = "backup";
    };
  };
}
