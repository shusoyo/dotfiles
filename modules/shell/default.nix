{ lib, pkgs, config, ss, ... }:

with lib;

let
  cfg = config.modules.shell.baseUtils;
in {
  imports = [
    ./git.nix
    ./elvish.nix
    ./nvim.nix
    ./yazi.nix
    ./fish.nix
  ];

  options.modules.shell.baseUtils = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.packages = with pkgs; [
      #                      -                      -
      # dash is used to run .sh script,
      # elvish is a new shell language to learn
      dash                   elvish

      # tools
      fzf                    ripgrep
      tree                   less
      htop                   unzip

      # Network tools
      wget                   curl

      # system info
      neofetch

      # safe rm, BUT rememebr don't alias rm to gtrash
      gtrash
      #                      -                      -
    ];

    home.shellAliases = {
      trash = "gtrash";
      ltr   = "gtrash put";
    };
  };
}
