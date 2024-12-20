{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.shell.yazi;
in {
  options.modules.shell.yazi = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.yazi.enable = true;
    xdg.configFile.yazi.source =
      ss.symlink "${ss.configDir}/yazi";
  };
}
