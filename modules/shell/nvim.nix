{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.shell.nvim;
in {
  options.modules.shell.nvim = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.neovim = {
      enable        = true;
      defaultEditor = true;
    };

    home.shellAliases = {
      v  = "nvim";
    };

    xdg.configFile.nvim.source = ss.cfgSymLink "nvim";
  };
}
