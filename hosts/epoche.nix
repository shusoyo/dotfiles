{ config, pkgs, ... }: {

  # Home Manager Infomations
  imports = [
    ./common.nix
  ];

  home.username = "epoche";
  home.homeDirectory = "/home/epoche";

  modules.dev = {
    cc.enable = true;
    # go.enable = true;
  };
}
