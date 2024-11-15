{ lib, config, options, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
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
        GOPATH = "${config.xdg.dataHome}/go";
        GOMODCACHE = "${config.xdg.cacheHome}/go/mod";
      };
      home.sessionPath = [
        "${config.xdg.dataHome}/go/bin"
      ];
    })
  ];
}

