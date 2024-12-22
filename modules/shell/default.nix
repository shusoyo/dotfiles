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
      fzf                    ripgrep
      zsh                    dash
      wget                   curl
      neofetch               tree
      unzip                  less
      htop                   gtrash
    ];
  };
}
