{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.shell.git;
in {
  options.modules.shell.git = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gitAndTools.git
      gitAndTools.gh
      gitAndTools.hut
      gitAndTools.lazygit
    ];

    home.shellAliases = {
      lg = "lazygit";
    };

    xdg.configFile = {
      "git/config".source = "${ss.config-path}/git/config";
      "git/ignore".source = "${ss.config-path}/git/ignore";

      "lazygit/config.yml".source = "${ss.config-path}/lazygit/config.yml";
    };
  };
}
