{ config, pkgs, tools, ... }: let 
  tools.sym = tools.sym config;
  tools.flake_path = tools.flake_path;
in {
  
  # Home Manager Infomations
  imports = [
    ../modules/common.nix
    ../modules/gui.nix
  ];
 
  home.username = "epoche";
  home.homeDirectory = "/Users/epoche";

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
