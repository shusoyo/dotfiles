{ ss, lib, config, pkgs, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.ocaml;
in {
  options.modules.dev.ocaml = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = [ pkgs.opam ];
    })

    (lib.mkIf cfg.xdg.enable {
      home.sessionVariables = {
        OPAMROOT="${config.xdg.dataHome}/opam";
      };
    })
  ];
}

