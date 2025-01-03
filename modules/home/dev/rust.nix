{ ss, lib, config, pkgs, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
in {
  options.modules.dev.rust = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.rustup ];
    })

    (lib.mkIf cfg.xdg.enable {
      home.sessionVariables = {
        RUSTUP_HOME = "${config.xdg.dataHome}/rustup";
        CARGO_HOME  = "${config.xdg.dataHome}/cargo";
      };

      home.sessionPath = [
        "${config.xdg.dataHome}/cargo/bin"
      ];
    })
  ];
}
