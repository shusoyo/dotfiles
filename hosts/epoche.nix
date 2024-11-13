{ config, pkgs, ... }: {

  # Home Manager Infomations
  imports = [
    ./common.nix
    ../modules/gui.nix
    ../modules/lib.nix
  ];

  home.username = "epoche";
  home.homeDirectory = "/Users/epoche";

  home.stateVersion = "24.05";
  programs.home-manager.enable = true;

  home.sessionPath = [ 
    "/usr/local/Cellar/ncurses/6.5/bin"
  ];

  home.sessionVariables = {
    HOMEBREW_API_DOMAIN        =     "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN     =     "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE   =     "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE   =     "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL     =     "https://pypi.tuna.tsinghua.edu.cn/simple";

    http_proxy                 =     "http://localhost:7890";
    https_proxy                =     "http://localhost:7890";
    ALL_PROXY                  =     "socks5://localhost:7890";

    # Lima vm home
    # LIMA_HOME                  =     "${config.xdg.dataHome}/lima";
    # VSCODE_PORTABLE            =     "${config.xdg.dataHome}/vscode";
    HISTFILE                   =     "${config.xdg.dataHome}/bash/history";
  };

  modules.dev = {
    ocaml.enable = true;
  };
}
