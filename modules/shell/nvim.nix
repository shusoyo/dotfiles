{ ss, lib, config, ... }:

let
  cfg = config.modules.shell.nvim;
  inherit (config) sl;
in {
  options.modules.shell.nvim = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    programs.neovim = {
      enable        = true;
      defaultEditor = true;
    };

    home.shellAliases = {
      v  = "nvim";
    };

    xdg.configFile.nvim.source = sl.symlink-to-config "nvim";
  };
}
