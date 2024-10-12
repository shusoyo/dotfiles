{ config, pkgs, tools, ... }: with tools; {
  
  # home.packages = with pkgs; [
  #   #                      -                      -                      -
  #   # kitty                   
  # ];

  programs.kitty.enable = true;
  programs.kitty.settings = {
    include = "${flakePath}/modules/kitty/kitty.conf";
  };
}
