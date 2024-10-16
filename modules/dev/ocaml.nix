{ lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.ocaml;
in {
  options.modules.dev.ocaml = {
    enable = mkOption { default = false; type = types.bool; };
    xdg.enable = mkOption { default = true; type = types.bool; };
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.opam ];
    })

    (mkIf cfg.xdg.enable {
      home.sessionVariables = {
        OPAMROOT="${config.xdg.dataHome}/opam";
      };
    #   home.sessionPath = [
    #     "$CARGO_HOME/bin"
    #   ];
    })
  ];
}

