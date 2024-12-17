{ ss, lib, config, options, pkgs, ... }: with lib;

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
    };

    xdg.configFile."wgetrc".text = ''
      hsts-file = ${config.xdg.cacheHome}/wget-hsts
    '';
  };
}
