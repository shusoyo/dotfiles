{ config, pkgs, ... }: {

  # Home Manager Infomations
  imports = [
    ./common.nix
    ../modules/lib.nix
  ];

  home.username = "epoche";
  home.homeDirectory = "/home/epoche";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;

  modules.dev = {
    cc.enable = true;
    # go.enable = true;
  };
}
