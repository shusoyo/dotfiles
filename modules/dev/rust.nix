{ lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
in {
  options.modules.dev.rust = {
    enable = mkOption { default = false; type = types.bool; };
    xdg.enable = mkOption { default = devCfg.xdg.enable; type = types.bool; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.rustup ];
    })

    (mkIf (cfg.xdg.enable && cfg.enable) {
      home.sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME = "${config.xdg.dataHome}/cargo";
      };
      home.sessionPath = [
        "${config.xdg.dataHome}/cargo/bin"
      ];
    })
  ];
}
