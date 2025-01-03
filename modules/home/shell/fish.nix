{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable     = ss.mkBoolOpt false;
    shellProxy = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      preferAbbrs = true;
      generateCompletions  = true;

      shellAbbrs = {
        cfg = "${config.xdg.configHome}";
        tpt   = "gtrash put";
        trash = "gtrash";
      };
    };

    programs.fish.shellInitLast = let
      shell-proxy-script  = if cfg.shellProxy then "set_proxy" else "";
      source-local-config = "[ -e ./local.fish ]; and source ./local.fish";
    in ''
      # terminal proxy script
      ${shell-proxy-script}
      # local config to debug or test.
      ${source-local-config}
    '';

    xdg.configFile = {
      "fish/functions" = {
        source = "${ss.config-path}/fish/functions";
        recursive = true;
      };

      # I don't know what is fish_variables (universal variables)
      "fish/fish_variables".source =
        config.adhoc.symlink-to-config "fish/fish_variables";
    };
  };
}
