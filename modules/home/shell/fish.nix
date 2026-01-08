{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.shell.fish;
in {
  options.modules.shell.fish = {
    enable     = ss.mkBoolOpt false;
    shellProxy = ss.mkOpt (lib.types.nullOr lib.types.str) null;
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable              = true;
      preferAbbrs         = true;
      generateCompletions = true;

      loginShellInit = let
        ocaml-eval =
          if config.modules.dev.ocaml.enable == true then
            "test -r '/Users/suspen/.local/share/opam/opam-init/init.fish' && source '/Users/suspen/.local/share/opam/opam-init/init.fish' > /dev/null 2> /dev/null; or true"
            # "eval (opam env)"
          else
            ""
        ;
      in ''
        # ocaml auto eval
        ${ocaml-eval}

        #homebrew shellenv
        eval "$(/opt/homebrew/bin/brew shellenv)"
      '';

      interactiveShellInit = let
        shell-proxy-script =
          if cfg.shellProxy != null then "set_proxy ${cfg.shellProxy}" else ""
        ;
        source-local-config =
          "[ -e ./local.fish ]; and source ./local.fish"
        ;
      in ''
        # terminal proxy script
        ${shell-proxy-script}
        # local config to debug or test.
        ${source-local-config}
      '';

      functions.ns = ''
        set -l flakeHome "${ss.abs-flake-path}"
        set -x NH_FLAKE $flakeHome

        switch $argv[1]
            case e
                $EDITOR $flakeHome
            case sh
                nh home switch
            case sn
                nh os switch
            case sd
                nh darwin switch
            case cd
                cd $flakeHome
            case "*"
                nh $argv
        end
      '';
    };

    xdg.configFile = {
      "fish/functions" = {
        source = "${ss.config-path}/fish/functions";
        recursive = true;
      };

      "fish/conf.d" = {
        source = "${ss.config-path}/fish/conf.d";
        recursive = true;
      };

      # Universal variables
      "fish/fish_variables".source =
        config.adhoc.symlink-to-config "fish/fish_variables";
    };
  };
}
