{ ss, lib, config, ... }:

let
  cfg = config.modules.shell.yazi;
  inherit (config) sl;
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

    xdg.configFile = with ss; {
      "yazi/init.lua".source     = "${ss.configDir'}/yazi/init.lua";
      "yazi/yazi.toml".source    = sl.symlink-to-config "yazi/yazi.toml";
      "yazi/package.toml".source = sl.symlink-to-config "yazi/package.toml";
    };
  };
}
