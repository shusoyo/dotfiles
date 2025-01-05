{ lib, pkgs, config, ss, ... }: {

  imports = [
    ./git.nix
    ./nvim.nix
    ./yazi.nix
    ./fish.nix
  ];

  # safe rm, BUT rememebr don't alias rm to gtrash
  home.packages = [
    pkgs.gtrash
  ];

  home.shellAliases = {
    g  = "gtrash";
    gp = "gtrash put";
    rm = "echo 'Better use gtrash'; command rm -i";
  };

  programs.fish.shellAbbrs = {
    cfg = "cd ${config.xdg.configHome}";
  };
}
