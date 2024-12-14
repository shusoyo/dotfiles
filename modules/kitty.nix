{ ss, lib, config, options, pkgs, ... }:

with lib;

let 
  cfg = config.modules.kitty;
in {
  options.modules.kitty = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xdg.configFile.kitty.source = 
      ss.symlink "${ss.configDir}/kitty";
  };
}
