{ lib, config, pkgs, ... }:

with lib;

let
  t = config.lib.tools;
  devCfg = config.modules.dev;
  cfg = devCfg.cc;
in {
  options.modules.dev.cc = {
    enable = t.mkBoolOpt false;
    xdg.enable = t.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        # clang
        # gcc
        clang-tools
        # bear
        # cmake
        # llvmPackages.libcxx

        # # Respect XDG, damn it!
        # (mkWrapper gdb ''
        #   wrapProgram "$out/bin/gdb" --add-flags '-q -x "${config.xdg.configHome}/gdb/init"'
        # '')
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
