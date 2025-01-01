{ ss, lib, config, ... }:

let
  cfg = config.modules.app.zed;
  inherit (config) sl;
in {
  options.modules.app.zed = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "zed/settings.json".source = sl.symlink-to-config "zed/settings.json";
    };
  };
}
