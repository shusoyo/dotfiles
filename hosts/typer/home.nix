{ inputs, pkgs, ss, config, ... }: {

  imports = [
    ../prelude/home.nix
    ../../modules/home/desktop
    ../../modules/home/packages/homebrew.nix
  ];

  # osx ad-hoc packages
  home.packages = with pkgs; [
    # GNU coreutils is used to replaced with apple xcode-develop-tools
    coreutils

    # nix language server for zed editor.
    nixd                  nil
  ];

  modules.packages.homebrew = {
    enable = true;

    taps = [
      #                           -
    ];

    brews = [
      "syncthing"

      "docker"
      "docker-compose"
    ];

    casks = [
      #                           -
      "wechat"
      "qq"
      "google-chrome"
      "zotero"

      # Develop
      "kitty"
      "zed"
      "visual-studio-code"

      # Do something in better way
      "the-unarchiver"
      "appcleaner"
    ];
  };

  modules = {
    shell = {
      fish.shellProxy = null;
    };

    app = {
      zed.enable   = true;
      kitty.enable = true;
    };

    dev = {
      lean.enable    = true;
      node.enable    = true;
      ocaml.enable   = true;
      typst.enable   = true;
      haskell.enable = true;
    };
  };
}
