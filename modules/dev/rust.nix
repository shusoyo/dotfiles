{ ss, lib, config, pkgs, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.rust;
  inherit (config) sl;
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
        RUSTUP_HOME = "${sl.dataHome}/rustup";
        CARGO_HOME  = "${sl.dataHome}/cargo";
      };

      home.sessionPath = [
        "${sl.dataHome}/cargo/bin"
      ];
    })
  ];
}
