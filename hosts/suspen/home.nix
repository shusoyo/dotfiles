{ inputs, pkgs, ss, config, ... }: {

  imports = [
    ../common.nix
    ../../modules/adhoc/homebrew.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.sshKeyPaths = [ "${ss.homeDirectory}/.ssh/id_ed25519" ];

    secrets."age-master-key" = {
      path = "${config.xdg.configHome}/sops/age/keys.txt";
    };

    secrets."ssh-hosts" = {
      path = "${ss.homeDirectory}/.ssh/config.d/ssh-hosts.config";
    };
  };

  home = {
    inherit (ss) username homeDirectory;

    packages = with pkgs; [
      # GNU coreutils is used to replaced with apple xcode-develop-tools
      coreutils

      # nix language server for zed editor.
      nixd                      nil

      sops                      age
    ];
  };

  modules.adhoc.homebrew = {
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
