# I am learning...
{ ss, lib, config, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.node;
in {
  options.modules.dev.node = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [];
    })

    (lib.mkIf cfg.xdg.enable {
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
