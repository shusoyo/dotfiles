{ ss, lib, config, ... }:

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
      # wget-hsts
      WGETRC         = "${config.xdg.configHome}/wgetrc";

      # bash-history
      HISTFILE       = "${config.xdg.dataHome}/bash/history";

      # sqlite_history
      SQLITE_HISTORY = "${config.xdg.dataHome}/sqlite_history";

      # Lima vm home
      # LIMA_HOME                  =     "${config.xdg.dataHome}/lima";
      # VSCODE_PORTABLE            =     "${config.xdg.dataHome}/vscode";
    };

    # wgetrc
    xdg.configFile."wgetrc".text = ''
      hsts-file = ${config.xdg.cacheHome}/wget-hsts
    '';
  };
}
