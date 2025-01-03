{ ss, lib, config, ... }:

let
  cfg = config.modules.app.kitty;
in {
  options.modules.app.kitty = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile.kitty.source = config.adhoc.symlink-to-config "kitty";
  };
}
