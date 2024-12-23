{ lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
  inherit (config.xdg) dataHome;
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
        RUSTUP_HOME = "${dataHome}/rustup";
        CARGO_HOME = "${dataHome}/cargo";
      };

      home.sessionPath = [
        "${dataHome}/cargo/bin"
      ];
    })
  ];
}
