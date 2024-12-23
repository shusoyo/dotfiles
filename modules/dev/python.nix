{ lib, config, pkgs, ss, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.python;
  inherit (config.xdg) dataHome cacheHome;
in {
  options.modules.dev.python = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        python313
        uv
      ];
    })

    (mkIf (cfg.xdg.enable && cfg.enable) {
      home.sessionVariables = {
        # Internal
        PYTHONUSERBASE      = "${dataHome}/python";
        PYTHON_HISTORY      = "${dataHome}/python/python_history"; # default value as of >=3.4
        PYTHONPYCACHEPREFIX = "${cacheHome}/python";
      };
    })
  ];
}
