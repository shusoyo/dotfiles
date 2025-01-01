{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.shell.git;
  inherit (config) sl;
in {
  options.modules.shell.git = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    home.packages = with pkgs; [
      gitAndTools.gh
      gitAndTools.hut
      gitAndTools.lazygit
    ];

    xdg.configFile = with ss; {
      "git/config".source = "${ss.configDir'}/git/config";
      "git/ignore".source = "${ss.configDir'}/git/ignore";

      "lazygit/config.yml".source = "${ss.configDir'}/lazygit/config.yml";
    };

    home.shellAliases = {
      lg = "lazygit";
    };
  };
}
