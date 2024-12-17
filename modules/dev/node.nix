{ lib, config, options, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.node;
in {
  options.modules.dev.node = {
    enable = mkOption { default = false; type = types.bool; };
    xdg.enable = mkOption { default = devCfg.xdg.enable; type = types.bool; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [];
    })

    (mkIf (cfg.xdg.enable && cfg.enable) {
      home.sessionVariables = {
        NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
        NODE_REPL_HISTORY     = "${config.xdg.dataHome}/node_repl_history";
      };

      xdg.configFile."npm/npmrc".text = ''
        prefix=${config.xdg.dataHome}/npm
        cache=${config.xdg.cacheHome}/npm
        init-module=${config.xdg.configHome}/npm/config/npm-init.js
        logs-dir=${config.xdg.stateHome}/npm/logs
      '';
    })
  ];
}

