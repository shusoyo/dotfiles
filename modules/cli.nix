{ config, pkgs, ss, ... }: with ss; {

  ## NEOVIM editor
  xdg.configFile.nvim.source = 
    symlink "${ss.configDir}/nvim";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  ## YAZI file manager
  programs.yazi.enable = true; 
  xdg.configFile.yazi.source = 
    symlink "${ss.configDir}/yazi";

  ## elvish shell config folder
  xdg.configFile.elvish.source = 
    symlink "${ss.configDir}/elvish";

  ## kitty terminal
  xdg.configFile.kitty.source = 
    symlink "${ss.configDir}/kitty";
 }
