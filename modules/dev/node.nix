# I am learning...
{ ss, lib, config, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.node;
  inherit (config) sl;
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
        NPM_CONFIG_USERCONFIG = "${sl.configHome}/npm/npmrc";
        NODE_REPL_HISTORY     = "${sl.dataHome}/node_repl_history";
      };

      xdg.configFile."npm/npmrc".text = ''
        prefix=${sl.dataHome}/npm
        cache=${sl.cacheHome}/npm
        init-module=${sl.configHome}/npm/config/npm-init.js
        logs-dir=${sl.stateHome}/npm/logs
      '';
    })
  ];
}
