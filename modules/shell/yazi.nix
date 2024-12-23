{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.shell.yazi;
in {
  options.modules.shell.yazi = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };

    home.shellAliases = {
      yz = "yazi";
    };

    xdg.configFile = {
      "yazi/init.lua".source     = ss.symlink "${ss.configDir}/yazi/init.lua";
      "yazi/yazi.toml".source    = ss.symlink "${ss.configDir}/yazi/yazi.toml";
      "yazi/package.toml".source = ss.symlink "${ss.configDir}/yazi/package.toml";
    };
  };
}
