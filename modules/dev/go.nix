# I am learning...
{ ss, lib, config, pkgs, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.go;
  inherit (config) sl;
in {
  options.modules.dev.go = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.go ];
    })

    (lib.mkIf cfg.xdg.enable {
      home.sessionVariables = {
        GOPATH = "${sl.dataHome}/go";
        GOMODCACHE = "${sl.cacheHome}/go/mod";
      };

      home.sessionPath = [
        "${sl.dataHome}/go/bin"
      ];
    })
  ];
}
