{ config, pkgs, ... }: with config.lib.tools; {

  ## NEOVIM editor
  xdg.configFile.nvim.source = 
    symlink "${flakePath}/config/nvim";
  programs.neovim = {
    enable = true;
    defaultEditor = true;
  };

  ## YAZI file manager
  programs.yazi.enable = true; 
  xdg.configFile.yazi.source = 
    symlink "${flakePath}/config/yazi";

  ## elvish shell config folder
  xdg.configFile.elvish.source = 
    symlink "${flakePath}/config/elvish";

  ## lazygit
  xdg.configFile.lazygit.source = 
    symlink "${flakePath}/config/lazygit";

  home.packages = [
    pkgs.git
    pkgs.lazygit
  ];
 }
