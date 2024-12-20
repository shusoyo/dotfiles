{ ss, lib, config, pkgs, ... }:

with lib;

let
  cfg = config.modules.shell.elvish;
in {
  options.modules.shell.elvish = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = [
      pkgs.elvish
    ];

    xdg.configFile.elvish.source =
      ss.symlink "${ss.configDir}/elvish";
  };
}
