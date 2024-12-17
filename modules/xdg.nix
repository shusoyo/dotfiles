{ ss, lib, config, options, ... }:

with lib;

let
  cfg = config.modules.xdg;
in {
  options.modules.xdg = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    xdg.enable = true;

    home.sessionVariables = {
      WGETRC = "${config.xdg.configHome}/wgetrc";
      # Lima vm home
      # LIMA_HOME                  =     "${config.xdg.dataHome}/lima";
      # VSCODE_PORTABLE            =     "${config.xdg.dataHome}/vscode";
      # HISTFILE                   =     "${config.xdg.dataHome}/bash/history";
    };

    xdg.configFile."wgetrc".text = ''
      hsts-file = ${config.xdg.cacheHome}/wget-hsts
    '';
  };
}
