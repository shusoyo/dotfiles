# Cargo run!
{ ss, lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
  inherit (config.xdg) dataHome;
in {
  options.modules.dev.rust = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.rustup ];
    })

    (mkIf cfg.xdg.enable {
      home.sessionVariables = {
        RUSTUP_HOME = "${dataHome}/rustup";
        CARGO_HOME  = "${dataHome}/cargo";
      };

      home.sessionPath = [
        "${dataHome}/cargo/bin"
      ];
    })
  ];
}
