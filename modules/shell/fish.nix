{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    programs.fish = {
      enable = true;
      generateCompletions = false;
    };

    xdg.configFile = with ss; {
      "fish/functions".source = symlink "${configDir}/fish/functions";
    };
  };
}
