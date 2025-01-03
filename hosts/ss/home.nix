{ inputs, pkgs, ss, config, ... }: {

  imports = [
    ../general-home-config.nix
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
      # Fonts
      "font-fira-code-nerd-font"
      "font-fira-mono"            "font-fira-code"
      "font-noto-sans-cjk"        "font-noto-serif-cjk"
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

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.sshKeyPaths = [ "${config.home.homeDirectory}/.ssh/id_ed25519" ];

    secrets."age-master-key" = {
      path = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    secrets."ssh-hosts" = {
      path = "${config.home.homeDirectory}/.ssh/config.d/ssh-hosts.config";
    };
  };

  modules = {
    ssh.enable = true;

    shell = {
      fish.shellProxy = true;
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
