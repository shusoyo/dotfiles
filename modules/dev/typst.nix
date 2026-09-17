# Typst: A typesetting software simpler than Latex.
{ lib, config, pkgs, ss, ... }:

let
  cfg = config.modules.dev.typst;
in {
  options.modules.dev.typst = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    user.packages = with pkgs; [
      typst
      # tinymist
    ];
  };
}

