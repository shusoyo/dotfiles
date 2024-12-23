{ ss, lib, config, pkgs, ... }:

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.ocaml;
  inherit (config.xdg) dataHome;
in {
  options.modules.dev.ocaml = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = [ pkgs.opam ];
    })

    (mkIf cfg.xdg.enable {
      home.sessionVariables = {
        OPAMROOT="${dataHome}/opam";
      };
    })
  ];
}

