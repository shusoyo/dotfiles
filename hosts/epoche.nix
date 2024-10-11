{ config, pkgs, ... }: {
  
  # Home Manager Infomations
  imports = [
    ../modules/common.nix
  ];
 
  home.username = "epoche";
  home.homeDirectory = "/Users/epoche";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
