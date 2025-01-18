{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.fish;
in {
  options.modules.fish = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    environment.shells = [ pkgs.fish ];

    programs.fish = {
      enable       = true;
      useBabelfish = true;
    };
  };
}
