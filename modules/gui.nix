{ config, pkgs, ... }: {
  
  # home.packages = with pkgs; [
  #   #                      -                      -                      -
  #   # kitty                   
  # ];

  programs.kitty.enable = true;
  programs.kitty.settings = {
    include = "${config.home.homeDirectory}/home-manager/modules/kitty/kitty.conf";
  };
}
