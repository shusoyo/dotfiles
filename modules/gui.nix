{ config, pkgs, tools, ... }: with config.lib.tools; {
 
  # home.packages = with pkgs; [
  #   #                      -                      -                      -
  # ];

  programs.kitty.enable = true;
  programs.kitty.settings = {
    include = "${flakePath}/config/kitty/kitty.conf";
  };
}
