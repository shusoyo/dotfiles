{ config, pkgs, ss, ... }: {

  imports = [
    ../common.nix
    ./homebrew.nix
  ];

  home.username = ss.username;
  home.homeDirectory = ss.homeDirectory;

  # home.sessionPath = [ 
  #   "/usr/local/Cellar/ncurses/6.5/bin"
  # ];

  home.sessionVariables = {
    # http_proxy                 =     "http://localhost:7890";
    # https_proxy                =     "http://localhost:7890";
    # ALL_PROXY                  =     "socks5://localhost:7890";

    # Lima vm home
    # LIMA_HOME                  =     "${config.xdg.dataHome}/lima";
    # VSCODE_PORTABLE            =     "${config.xdg.dataHome}/vscode";
    # HISTFILE                   =     "${config.xdg.dataHome}/bash/history";
  };

  modules.dev = {
    # ocaml.enable = true;
    node.enable = true;
  };
}

# substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
#
# experimental-features = nix-command flakes
#
# trusted-users = root suspen epoche
# build-users-group = nixbld

