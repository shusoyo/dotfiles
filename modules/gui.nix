{ config, pkgs, tools, ... }: with config.lib.tools; {
 
  # home.packages = with pkgs; [
  #   #                      -                      -                      -
  # ];

  programs.kitty.enable = true;
  programs.kitty.settings = {
    include = "${flakePath}/modules/kitty/kitty.conf";
  };
}
