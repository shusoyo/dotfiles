{ config, pkgs, tools, ... }: with tools; {

  ## NEOVIM editor
  # 2 way that make symbol link to manager config file 
  xdg.configFile.nvim.source = 
    sym config "${flake_path config}/modules/nvim";
  
  programs.neovim = {
    enable = true;
  
    defaultEditor = true;
    withPython3 = true;
    
    extraPackages = with pkgs; [
      # fd
      # gh # for github integration
      ripgrep # used by obsidian.nvim and other plugins

      # needed to compile fzf-native for telescope-fzf-native.nvim
      gcc
      # gnumake

      # language servers
      # deno
      lua-language-server
      nil # Nix LSP
      # nls # Nickel LSP
      # nodePackages.bash-language-server
      # nodePackages.typescript-language-server
      # shellcheck # called by bash-language-server

      # Rust support
      # lldb # debug adapter
      # graphviz # to render crate graphs from rustaceanvim

      # nixpkgs-fmt # I have nil configured to call this for formatting
    ];
  };

  ## YAZI file manager
  xdg.configFile."yazi/yazi.toml".source = 
    sym config "${flake_path config}/modules/yazi/yazi.toml";
  xdg.configFile."yazi/package.toml".source = 
    sym config "${flake_path config}/modules/yazi/package.toml";
  xdg.configFile."yazi/theme.toml".source = 
    sym config "${flake_path config}/modules/yazi/theme.toml";
  xdg.configFile."yazi/init.lua".source = 
    sym config "${flake_path config}/modules/yazi/init.lua";
  
  programs.yazi.enable = true; 
  # shellWrapperName = "y";
 }
