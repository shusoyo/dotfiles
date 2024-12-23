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
      # loginShellInit = mkIf pkgs.stdenv.isDarwin ''
      #   if test -f /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      #     source /nix/var/nix/profiles/default/etc/profile.d/nix-daemon.fish
      #   end
      # '';
    };

    xdg.configFile = with ss; {
      "fish/functions".source      = symlink "${configDir}/fish/functions";
      "fish/fish_variables".source = symlink "${configDir}/fish/fish_variables";
    };

    home.shellAliases = {
      ghm   = "cd ~/.config/home-manager";
      trash = "gtrash";
      ltr   = "gtrash put";
    };
  };
}
