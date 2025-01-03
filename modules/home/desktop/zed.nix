{ ss, lib, config, ... }:

let
  cfg = config.modules.app.zed;
in {
  options.modules.app.zed = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile = {
      "zed/settings.json".source = config.adhoc.symlink-to-config "zed/settings.json";
    };
  };
}
