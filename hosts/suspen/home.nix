{ pkgs, ss, ... }: {

  imports = [
    ../common.nix
    ./homebrew.nix
  ];

  home.username = ss.username;
  home.homeDirectory = ss.homeDirectory;

  home.packages = with pkgs; [
    # GNU coreutils is used to replaced with apple xcode-develop-tools
    coreutils

    # nix language server for zed editor.
    nixd                      nil
  ];

  modules = {
    app = {
      kitty.enable = true;
      zed.enable   = true;
    };

    dev = {
      node.enable  = true;
      typst.enable = true;
    };
  };
}
