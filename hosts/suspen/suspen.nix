{ config, pkgs, ss, ... }: {

  imports = [
    ../common.nix
    ./homebrew.nix
  ];

  home.username = ss.username;
  home.homeDirectory = ss.homeDirectory;

  home.packages = with pkgs; [
    hugo
    coreutils
  ];

  home.sessionVariables = {
    # http_proxy                 =     "http://localhost:7890";
    # https_proxy                =     "http://localhost:7890";
    # ALL_PROXY                  =     "socks5://localhost:7890";

    # Lima vm home
    # LIMA_HOME                  =     "${config.xdg.dataHome}/lima";
    # VSCODE_PORTABLE            =     "${config.xdg.dataHome}/vscode";
    # HISTFILE                   =     "${config.xdg.dataHome}/bash/history";
  };

  modules = {
    kitty.enable = true; 

    dev = {
      # ocaml.enable = true;
      node.enable  = true;
      typst.enable = true;
    };
  };
}
