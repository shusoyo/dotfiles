# I am learning...
{ ss, lib, config, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.node;
  inherit (config.xdg) stateHome configHome dataHome cacheHome;
in {
  options.modules.dev.node = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [];
    })

    (mkIf cfg.xdg.enable {
      home.sessionVariables = {
        NPM_CONFIG_USERCONFIG = "${configHome}/npm/npmrc";
        NODE_REPL_HISTORY     = "${dataHome}/node_repl_history";
      };

      xdg.configFile."npm/npmrc".text = ''
        prefix=${dataHome}/npm
        cache=${cacheHome}/npm
        init-module=${configHome}/npm/config/npm-init.js
        logs-dir=${stateHome}/npm/logs
      '';
    })
  ];
}
