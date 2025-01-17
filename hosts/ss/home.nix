{ inputs, pkgs, ss, config, ... }: {

  imports = [
    ../general/home.nix
    ../../modules/home/desktop
    ../../modules/home/packages/homebrew.nix
    inputs.sops-nix.homeManagerModules.sops
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
      "homebrew/bundle"           "homebrew/services"
    ];

    brews = [
      "bitwarden-cli"
    ];

    casks = [
      #                           -
      "appcleaner"                "wechat"
      "bitwarden"                 "telegram-a"
      "baidunetdisk"
      #                           -
      # Web Browser
      "arc"                       "zen-browser"
      # Develop
      "ghostty"                   "utm"
      "kitty"                     "zed"
      "visual-studio-code"
      # Do something in better way
      "syncthing"
      "mos"                       "raycast"
      "sfm"                       "clash-verge-rev"
    ];
  };

  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
  };

  modules = {
    ssh.enable = true;

    shell = {
      fish.shellProxy = false;
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
