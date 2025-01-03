# As the most basic language in a system even complie the system compoment
# Use the system support toolchian and tools firstly.
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
        clang-tools
      ];
    })

    (mkIf cfg.xdg.enable {
      # TODO
    })
  ];
}
