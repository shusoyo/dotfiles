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
      "bitwarden-cli"
    ];

    casks = [
      #                           -
      "qq"
      "wechat"
      "baidunetdisk"
      "bitwarden"
      "google-chrome"
      #                           -
      # Web Browser
      "arc"

      # Develop
      "ghostty"
      "utm"
      "kitty"
      "zed"
      "visual-studio-code"

      # Do something in better way
      "xmind"
      "syncthing-app"
      "sfm"
      "clash-verge-rev"
      "mos"
      "raycast"
      "the-unarchiver"
      "appcleaner"
    ];
  };

  modules.sops = {
    enable = true;
  };

  modules = {
    ssh.enable = true;

    shell = {
      fish.shellProxy = null;
    };

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
