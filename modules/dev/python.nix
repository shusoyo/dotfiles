{ lib, config, pkgs, ss, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.python;
  inherit (config) sl;
in {
  options.modules.dev.python = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        python313
        uv
      ];
    })

    (lib.mkIf cfg.xdg.enable {
      home.sessionVariables = {
        PYTHONUSERBASE      = "${sl.dataHome}/python";
        PYTHON_HISTORY      = "${sl.dataHome}/python/python_history"; 
        PYTHONPYCACHEPREFIX = "${sl.cacheHome}/python";
      };
    })
  ];
}
