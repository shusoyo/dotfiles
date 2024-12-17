{ lib, config, pkgs, ss, ... }: 

with lib;

let
  devCfg = config.modules.dev;
  cfg = devCfg.cc;
in {
  options.modules.dev.cc = {
    enable = ss.mkBoolOpt false;
    xdg.enable = ss.mkBoolOpt devCfg.xdg.enable;
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
