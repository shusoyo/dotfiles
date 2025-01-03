{ ss, lib, config, ... }:

let
  cfg = config.modules.shell.yazi;
in {
  options.modules.shell.yazi = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    programs.yazi = {
      enable = true;
      shellWrapperName = "y";
    };

    home.shellAliases = {
      yz = "yazi";
    };

    xdg.configFile = {
      "yazi/init.lua".source     = "${ss.config-path}/yazi/init.lua";
      "yazi/yazi.toml".source    = "${ss.config-path}/yazi/yazi.toml";
      "yazi/package.toml".source = config.adhoc.symlink-to-config "yazi/package.toml";
    };
  };
}
