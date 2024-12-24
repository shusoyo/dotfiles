{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.app.kitty;
in {
  options.modules.app.kitty = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xdg.configFile.kitty.source = ss.cfgSymLink "kitty";
  };
}
