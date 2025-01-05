{ ss, pkgs, lib, config, ... }:

let
  cfg = config.modules.shell.nvim;
in {
  options.modules.shell.nvim = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    home.packages = [
      pkgs.neovim
    ];

    home.sessionVariables = {
      EDITOR = "nvim";
      VISUAL = "nvim";
    };

    home.shellAliases = {
      v  = "nvim";
    };

    xdg.configFile.nvim.source =
      config.adhoc.symlink-to-config "nvim";
  };
}
