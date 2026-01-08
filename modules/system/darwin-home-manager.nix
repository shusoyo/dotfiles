{ inputs, config, lib, ss, pkgs, ... }:

let
  cfg = config.modules.home-manager;
in {
  imports = [ inputs.home-manager.darwinModules.home-manager ];

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
