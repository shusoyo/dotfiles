{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.app.zed;
in {
  options.modules.app.zed = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xdg.configFile."zed/settings.json".source =
      ss.symlink "${ss.configDir}/zed/settings.json";
  };
}
