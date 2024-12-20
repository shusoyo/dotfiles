{ pkgs, ss, ... }: {

  imports = [
    ../common.nix
    ./homebrew.nix
  ];

  home.username = ss.username;
  home.homeDirectory = ss.homeDirectory;

  home.packages = with pkgs; [
    # blog (generate static pages in local)
    hugo

    # GNU coreutils is used to replaced with apple xcode-develop-tools
    coreutils

    # nix language server for zed editor.
    nixd                      nil
  ];

  home.sessionVariables = {
    # http_proxy                 =     "http://localhost:7890";
    # https_proxy                =     "http://localhost:7890";
    # ALL_PROXY                  =     "socks5://localhost:7890";
  };

  modules = {
    app = {
      kitty.enable = true;
      zed.enable   = true;
    };

    dev = {
      # ocaml.enable = true;
      node.enable  = true;
      typst.enable = true;
    };
  };
}
