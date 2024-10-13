{ config, pkgs, tools, ... }: with config.lib.tools; {
 
  programs.kitty.enable = true;
  programs.kitty.settings = {
    include = "${flakePath}/modules/kitty/kitty.conf";
  };
}
