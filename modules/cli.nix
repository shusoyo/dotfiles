{ config, pkgs, ... }: {

  ## NEOVIM editor
  # 2 way that make symbol link to manager config file 
  #
  # xdg.configFile.nvim = {
  #   source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/home-manager/modules/nvim";
  # };

  # home.file.".config/nvim" = {
  #   source = ./nvim;
  # };
  #
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
  
  home.file = {
    ".config/yazi/yazi.toml".source = ./yazi/yazi.toml;
    ".config/yazi/theme.toml".source = ./yazi/theme.toml;
    ".config/yazi/package.toml".source = ./yazi/package.toml;
    ".config/yazi/init.lua".source = ./yazi/init.lua;
  };

  programs.yazi = let 
    # yazi-plugins = 
    #   pkgs.fetchFromGitHub { owner = "yazi-rs"; repo = "plugins"; rev = "main"; };
    # sym = 
    #   src: tar: xdg.configFile."${src}".source = "${config.home.homeDirectory}/home-manager/modules/${src}"; 
  in {
    enable = true;
    # shellWrapperName = "y";
      
		# plugins = {
		# 	full-border = "${yazi-plugins}/full-border.yazi";
		#     no-status   = "${yazi-plugins}/no-status.yazi";
		# };
  };
 }
