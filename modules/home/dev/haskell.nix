{ ss, lib, config, pkgs, ... }:

let
  devCfg = config.modules.dev;
  cfg = devCfg.haskell;
in {
  options.modules.dev.haskell = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
  };

  config = lib.mkMerge [
    (lib.mkIf cfg.enable {
      home.packages = with pkgs; [
        (agda.withPackages (p: [
          p.standard-library
        ]))
        # ghc
        # cabal-install
        # haskell-language-server
      ];
    })

    (lib.mkIf cfg.xdg.enable {
      home.sessionVariables = {
      };
    })
  ];
}

