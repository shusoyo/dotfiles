{ ss, lib, config, pkgs, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.lean;
in {
  options.modules.dev.lean = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.elan ];
    })

    (lib.mkIf cfg.xdg.enable {
      home.sessionVariables = {
        ELAN_HOME = "${config.xdg.configHome}/elan";
      };
    })
  ];
}
