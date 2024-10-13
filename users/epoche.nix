{ config, pkgs, ... }: {
  
  # Home Manager Infomations
  imports = [
    ../modules/common.nix
    ../modules/gui.nix
    ../modules/lib.nix
  ];
 
  home.username = "epoche";
  home.homeDirectory = "/Users/epoche";

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
  };
  
  lib = {
    plus = {
      f = x: x + 1;
    };
  };

  home.stateVersion = "24.05";

  programs.home-manager.enable = true;
}
