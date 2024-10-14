{ config, pkgs, ... }: with config.lib.tools; {

  ## NEOVIM editor
  xdg.configFile.nvim.source = 
    symlink "${flakePath}/modules/nvim";

  programs.neovim = {
    enable = true;
    defaultEditor = true;
    withPython3 = true;

    extraPackages = with pkgs; [
      ripgrep
      gcc

      luajit          luajitPackages.luarocks-nix
      # language servers
      lua-language-server
      nil
    ];
  };

  ## YAZI file manager
  programs.yazi.enable = true; 
  xdg.configFile.yazi.source = 
    symlink "${flakePath}/modules/yazi";

  ## elvish shell config folder
  xdg.configFile.elvish.source = 
    symlink "${flakePath}/modules/elvish";

  ## git
  programs.git.enable = true;
 }
