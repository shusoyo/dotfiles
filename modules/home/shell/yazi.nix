{ ss, pkgs, lib, config, ... }:

let
  cfg = config.modules.shell.yazi;
in {
  options.modules.shell.yazi = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    home.packages = [ pkgs.yazi ];

    home.shellAliases = {
      yz = "yazi";
    };

    xdg.configFile."yazi" = {
      source    = "${ss.config-path}/yazi";
      recursive = true;
    };
  };
}
