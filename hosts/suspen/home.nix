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
