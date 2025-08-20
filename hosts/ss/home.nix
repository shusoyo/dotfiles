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
      "syncthing-app"
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

  services.syncthing = {
    enable = true;
    settings = {
      gui = {
        user = "suspen";
        password = "1202";
      };
      devices = {
        "ss_iphone" = { id = "6D52CQG-JXIWTKB-QFDIRSH-7TFSQVS-OXWBMLW-R5MPXPO-24WGH2Y-LRBNPQT"; };
        "sis"    = { id = "NATNUA4-GMYZ7NI-JABFJ32-A7IKIP2-D4BW64G-LKUA4GR-6KV4CQA-QDX5QQ4"; };
      };
      folders = {
        "sync" = {
          path = "/Users/suspen/ss/sync";
          devices = [ "ss_iphone" "sis" ];
        };
      };
    };
  };
}
