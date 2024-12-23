{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.shell.fish;
  inherit (config.xdg) configHome;
in {
  options.modules.shell.fish = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      preferAbbrs = true;
      generateCompletions = false;
      shellInit = ''
        if test -e "${configHome}/fish/extra.fish";
          source ${configHome}/fish/extra.fish
        end
      '';
    };

    xdg.configFile = with ss; {
      "fish/functions".source      = symlink "${configDir}/fish/functions";
      "fish/extra.fish".source     = symlink "${configDir}/fish/extra.fish";

      # I don't know what is fish_variables
      "fish/fish_variables".source = symlink "${configDir}/fish/fish_variables";
    };
  };
}
