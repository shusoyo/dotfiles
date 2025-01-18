{ ss, lib, config, ... }:

let
  cfg = config.modules.headless;
in {
  options.modules.headless = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    fonts.fontconfig.enable = false;
  };
}
