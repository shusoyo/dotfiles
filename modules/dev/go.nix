{ lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.go;
  inherit (config.xdg) dataHome cacheHome;
in {
  options.modules.dev.go = {
    enable = mkOption { default = false; type = types.bool; };
    xdg.enable = mkOption { default = devCfg.xdg.enable; type = types.bool; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.go ];
    })

    (mkIf (cfg.xdg.enable && cfg.enable) {
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
