{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.xdg;
in {
  options.modules.xdg = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;
    xdg.cacheHome = config.home.homeDirectory + (
      if pkgs.stdenv.hostPlatform.isDarwin then
        "/Library/Caches"
      else
        "/.cache"
    );

    home.preferXdgDirectories = true;

    home.sessionVariables = with config.xdg; {
      # ./wget-hsts
      WGETRC = "${config.xdg.configHome}/wgetrc";

      # ./bash-history
      HISTFILE = "${config.xdg.dataHome}/bash/history";

      # ./sqlite_history
      SQLITE_HISTORY = "${config.xdg.dataHome}/sqlite_history";

      # ./lima
      # LIMA_HOME = "${config.xdg.dataHome}/lima";
      # COLIMA_HOME = "${config.xdg.configHome}/colima";

      DOCKER_CONFIG = "${config.xdg.configHome}/docker";

      ELAN_HOME = "${config.xdg.configHome}/elan";
    };


    # wgetrc
    xdg.configFile."wgetrc".text = ''
      hsts-file = ${config.xdg.cacheHome}/wget-hsts
    '';

    programs.man.generateCaches = lib.mkForce false;
  };
}
