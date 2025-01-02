{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.shell.fish;
  inherit (config) sl;
in {
  options.modules.shell.fish = {
    enable = ss.mkBoolOpt false;
    shellProxy = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    programs.fish = {
      enable = true;
      preferAbbrs = true;
      generateCompletions  = true;

      # fish script controlled by nix
      # loginShellInit =
      #  if pkgs.stdenv.hostPlatform.isDarwin then 
      #    ''''
      #  else
      #    '' source_sys_profiles '';

      shellInitLast = let
        shell-proxy-script =
          if cfg.shellProxy then "set_proxy" else "";

        source-local-config = "[ -e ./local.fish ]; and source ./local.fish";
      in ''
          # Extra config to debug or test.
          ${shell-proxy-script}

          ${source-local-config}
        '';

      shellAbbrs = {
        nds = "darwin-rebuild switch --flake ${ss.flakePath}";
        # hm  = "~/.config/home-manager";
        cfg = "~/.config/";
      };
    };

    xdg.configFile = {
      "fish/functions" = {
        source = "${ss.configDir'}/fish/functions";
        recursive = true;
      };

      # Extra config to debug
      # "fish/extra.fish".source = sl.symlink-to-config "fish/extra.fish";

      # I don't know what is fish_variables (universal variables)
      "fish/fish_variables".source = sl.symlink-to-config "fish/fish_variables";
    };
  };
}
