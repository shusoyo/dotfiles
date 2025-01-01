{ ss, lib, config, ... }:

let
  cfg = config.modules.app.kitty;
  inherit (config) sl;
in {
  options.modules.app.kitty = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile.kitty.source = sl.symlink-to-config "kitty";
  };
}
