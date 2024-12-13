{ config, options, pkgs, ... }:

with config.lib.tools;

let 
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    user.packages = with pkgs; [
    #   gitAndTools.git-annex
      gitAndTools.gh
    #   gitAndTools.git-open
    #   gitAndTools.diff-so-fancy
    #   (mkIf config.modules.shell.gnupg.enable
    #     gitAndTools.git-crypt)
    #   act
    ];

    xdg.configFile = {
      "git/config".source = "${hey.configDir}/git/config";
      "git/ignore".source = "${hey.configDir}/git/ignore";
      "git/attributes".source = "${hey.configDir}/git/attributes";
    };

    modules.shell.zsh.rcFiles = [ "${hey.configDir}/git/aliases.zsh" ];
  };
}
