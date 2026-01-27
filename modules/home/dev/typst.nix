# Typst: A typesetting software simpler than Latex.
{ lib, config, pkgs, ss, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.typst;
in {
  options.modules.dev.typst = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        typst
        # tinymist
      ];
    })

    (lib.mkIf cfg.xdg.enable {
      # Don't need specify the xdg path, typst don't make waste file in home.
    })
  ];
}

