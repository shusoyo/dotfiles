# modules/dev/cc.nix --- C & C++
#
# I like C. I tolerate C++. I like++ C with a few choice C++ features tacked on.
# Liking C/C++ seems to be an unpopular opinion, so it's my guilty secret.
# Don't tell anyone pls.

{ hey, lib, config, options, pkgs, ... }:

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
        gcc
        clang-tools
        # bear
        cmake
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
