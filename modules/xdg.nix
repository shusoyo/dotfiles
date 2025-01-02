{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.xdg;
  inherit (config) sl;
in {
  options.modules.xdg = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    xdg.enable = true;
    xdg.cacheHome = ss.homeDirectory + (
      if pkgs.stdenv.hostPlatform.isDarwin then
        "/Library/Caches"
      else
        "/.cache"
    );

    home.preferXdgDirectories = true;

    home.sessionVariables = with config.xdg; {
      # ./wget-hsts
      WGETRC = "${sl.configHome}/wgetrc";

      # ./bash-history
      HISTFILE = "${sl.dataHome}/bash/history";

      # ./sqlite_history
      SQLITE_HISTORY = "${sl.dataHome}/sqlite_history";

      # ./lima
      # LIMA_HOME = "${config.xdg.dataHome}/lima";
    };

    # wgetrc
    xdg.configFile."wgetrc".text = ''
      hsts-file = ${sl.cacheHome}/wget-hsts
    '';

    programs.man.generateCaches = lib.mkForce false;
  };
}
