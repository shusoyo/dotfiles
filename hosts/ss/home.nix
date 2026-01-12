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

    elan
  ];

  modules.packages.homebrew = {
    enable = true;

    taps = [
      #                           -
      "LizardByte/homebrew"
    ];

    brews = [
      "syncthing"

      "colima"
      "docker"
      "docker-compose"
    ];

    casks = [
      #                           -
      "qq"
      "wechat"
      "baidunetdisk"
      "bitwarden"
      "google-chrome"
      "arc"
      "zotero"


      # Develop
      "ghostty"
      "utm@beta"
      "kitty"
      "zed"
      "visual-studio-code"

      # Do something in better way
      # "syncthing-app"
      "sfm"
      "clash-verge-rev"
      "mos"
      "the-unarchiver"
      "appcleaner"

      "squirrel-app"
    ];
  };

  modules.sops = {
    enable = true;
    sopsFile = ./asserts/secrets.yaml;
  };

  modules = {
    # ssh.enable = true;

    shell = {
      fish.shellProxy = null;
    };

    app = {
      kitty.enable = true;
      zed.enable   = true;
    };

    dev = {
      node.enable  = true;
      ocaml.enable = true;
      typst.enable = true;
      haskell.enable = true;
    };
  };
}
