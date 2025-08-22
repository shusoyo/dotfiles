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
      "LizardByte/homebrew"
    ];

    brews = [
      # "sunshine"
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
      "utm"
      "kitty"
      "zed"
      "visual-studio-code"

      # Do something in better way
      "xmind"
      # "syncthing-app"
      "sfm"
      "clash-verge-rev"
      "mos"
      "the-unarchiver"
      "appcleaner"

      # "squirrel-app"
    ];
  };

  modules.sops = {
    enable = true;
    sopsFile = ./asserts/secrets.yaml;
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

  sops.secrets.syncthing-gui-password = {};

  services.syncthing = {
    enable = true;
    passwordFile = "${config.sops.secrets.syncthing-gui-password.path}";
    settings = {
      gui = {
        user = "suspen";
      };
      devices = {
        "sis"       = { id = "IUH3EWE-BRUOANF-KNMKID2-F5AEVLT-IHSSPUR-WSOR6XK-YA5V3QJ-2AEQ3AX"; };
        "ss_iphone" = { id = "6D52CQG-JXIWTKB-QFDIRSH-7TFSQVS-OXWBMLW-R5MPXPO-24WGH2Y-LRBNPQT"; };
        "ss_ipad"   = { id = "PJUAYSZ-GZ2VOZR-SMB2ZJL-AYRGQAI-FYXXDGI-TXBAYUI-B4ZVC6Q-RFBDHQI"; };
      };
      folders = {
        "sync" = {
          path = "/Users/suspen/ss/syncthing/sync";
          devices = [ "ss_iphone" "sis" "ss_ipad" ];
        };
        "backup" = {
          path = "/Users/suspen/ss/syncthing/backup";
          devices = [ "sis" ];
        };
      };
    };
  };
}
