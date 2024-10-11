{ config, pkgs, tools, ... }: with tools; {

  ## NEOVIM editor
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
      nil # Nix LSP          # nls # Nickel LSP
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
  xdg.configFile.yazi.source = 
    sym config "${flake_path config}/modules/yazi";

  programs.yazi.enable = true; 
  # shellWrapperName = "y";

  ## git
  programs.git.enable = true;
 }
