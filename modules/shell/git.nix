{ ss, lib, config, options, pkgs, ... }:

with lib;

let 
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      gitAndTools.gh
      gitAndTools.hut
      gitAndTools.lazygit
    ];

    xdg.configFile = {
      git.source     = ss.symlink "${ss.configDir}/git";
      lazygit.source = ss.symlink "${ss.configDir}/lazygit";
    };
   
  };
}
