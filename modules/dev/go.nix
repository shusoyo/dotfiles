# I am learning...
{ ss, lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.go;
  inherit (config.xdg) dataHome cacheHome;
in {
  options.modules.dev.go = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.go ];
    })

    (mkIf cfg.xdg.enable {
      home.sessionVariables = {
        GOPATH = "${dataHome}/go";
        GOMODCACHE = "${cacheHome}/go/mod";
      };

      home.sessionPath = [
        "${dataHome}/go/bin"
      ];
    })
  ];
}
