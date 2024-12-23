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
      generateCompletions  = true;

      # fish script controlled by nix
      loginShellInit = ''
        # Load the /etc/profile to get the system daemon related pathes
        exec dash -c "test -e /etc/profile && . /etc/profile; exec fish"
      '';

      # extra configuration
      shellInitLast = ''
        # Proxy settings functions is defined in functions folder with autoloading
        set_proxy

        # Extra config to debug or test.
        source ${configHome}/fish/extra.fish
      '';

      shellAbbrs = {
        ghm = "~/.config/home-manager";
        cfg = "~/.config/";
      };
    };

    xdg.configFile = with ss; {
      "fish/functions" = {
        source = ../../config/fish/functions;
        recursive = true;
      };

      # Extra config to debug
      "fish/extra.fish".source = symlink "${configDir}/fish/extra.fish";

      # I don't know what is fish_variables
      "fish/fish_variables".source = symlink "${configDir}/fish/fish_variables";
    };
  };
}
