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
    xdg.cacheHome = ss.homeDirectory + (
      if ss.system == "x86_64-darwin" then
        "/Library/Caches"
      else
        "/.cache"
    );

    home.preferXdgDirectories = true;

    home.sessionVariables = with config.xdg; {
      # ./wget-hsts
      WGETRC = "${configHome}/wgetrc";

      # ./bash-history
      HISTFILE = "${dataHome}/bash/history";

      # ./sqlite_history
      SQLITE_HISTORY = "${dataHome}/sqlite_history";

      # ./lima
      # LIMA_HOME = "${config.xdg.dataHome}/lima";
    };

    # wgetrc
    xdg.configFile."wgetrc".text = ''
      hsts-file = ${config.xdg.cacheHome}/wget-hsts
    '';

    programs.man.generateCaches = mkForce false;
  };
}
