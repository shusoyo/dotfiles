{ config, pkgs, ... }: {
  
  # Home Manager Infomations
  imports = [
    ./modules/common.nix
  ];

  home.username = "suspen";
  home.homeDirectory = "/home/suspen";

  home.stateVersion = "24.05";

  home.packages = with pkgs; [
    hello 
   ];

  programs.home-manager.enable = true;
}
