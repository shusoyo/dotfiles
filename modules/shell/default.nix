{ lib, pkgs, config, ss, ... }:

with lib;

let
  cfg = config.modules.shell.baseutils;
in {

  imports = [
    ./git.nix
    ./elvish.nix
    ./nvim.nix
    ./yazi.nix
  ];

  options.modules.shell.baseutils = {
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
      htop
    ];
  };
}
