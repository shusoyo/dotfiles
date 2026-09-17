{ pkgs, lib, config, ss, ... }: {

  imports = [
    ss.modules.sops-nix.sops
  ];

  # secretive
  home.sessionVariables = {
    SSH_AUTH_SOCK = "/Users/suspen/Library/Containers/com.maxgoedjen.Secretive.SecretAgent/Data/socket.ssh";
  };

  # Sops configuration
  sops = {
    age.generateKey = false;
    age.sshKeyPaths = [];
    gnupg.sshKeyPaths = [];

    defaultSopsFile = ./assets/secrets.yaml;
    age.keyFile = "${config.home.configDir}/sops/age/keys.txt";

    # environment.PATH = lib.mkForce (
    #   "${lib.makeBinPath config.sops.age.plugins}:/usr/bin:/bin:/usr/sbin:/sbin"
    # );

    secrets.hello = {
      owner = config.user.name; 
      group = "staff"; 
    };
  };

  # Host & User identity
  networking.hostName = "shu";
  system.primaryUser = config.user.name;

  user = {
    name = "suspen";
    home = "/Users/suspen";
  };

  # Modules options
  modules = {
    xdg.enable = true;

    shell = {
      fish.enable = true;
      git.enable  = true;
      nvim.enable = true;
      yazi.enable = true;
    };

    dev = {
      cc.enable     = true;
      typst.enable  = true;
      python.enable = true;
    };
  };

  # macOS GUI Applications config symlinks
  home.configFile = {
    kitty.source = "${ss.configDir}/kitty";
    "zed/settings.json".source = "${ss.configDir}/zed/settings.json";
  };

  # User packages
  user.packages = with pkgs; [
    # Nix language tooling
    nixd
    nil

    # Development & host utilities
    cliproxyapi
    dash
    sops
    age
  ];

  # Host services
  services.cliproxyapi.enable = true;

  # macOS System preferences
  system.stateVersion = 6;
  security.pam.services.sudo_local.touchIdAuth = true;

  system.defaults = {
    dock.autohide = true;
    dock.mru-spaces = false;
    finder.AppleShowAllExtensions = true;
    finder.FXPreferredViewStyle = "clmv";
    loginwindow.GuestEnabled = false;
    NSGlobalDomain = {
      ApplePressAndHoldEnabled = false;
      AppleICUForce24HourTime = true;
      AppleInterfaceStyle = "Dark";
      KeyRepeat = 2;
    };
  };

  # Nix configuration (Determinate Systems daemon)
  nix.enable = false;

  environment.etc."nix/nix.custom.conf".text = ''
    warn-dirty = false
    use-xdg-base-directories = true
    trusted-users = ${config.user.name} root
    builders-use-substitutes = true
    substituters = https://mirrors.ustc.edu.cn/nix-channels/store https://cache.nixos.org
  '';

  launchd.daemons.nix-gc = {
    command = "/nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-older-than 4d";
    serviceConfig.RunAtLoad = false;
    serviceConfig.StartCalendarInterval = [{ Weekday = 7; Hour = 3; Minute = 15; }];
  };

  environment.profiles = lib.mkForce [
    "/nix/var/nix/profiles/default"
    "/run/current-system/sw"
    "/etc/profiles/per-user/${config.user.name}"
    # "$HOME/.local/state/nix/profile"
  ];

  fonts.packages = with pkgs; [
    fira
    fira-code
    nerd-fonts.fira-code
    nerd-fonts.symbols-only
    julia-mono
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  time.timeZone = "Asia/Shanghai";

  # Darwin-specific shell optimizations
  programs.fish.useBabelfish = true;

  # Homebrew configuration
  homebrew = {
    enable = true;
    enableFishIntegration = true;
    onActivation.cleanup  = "zap";

    onActivation.extraEnv = {
      XDG_CONFIG_HOME          = "${config.home.configDir}";
      HOMEBREW_API_DOMAIN      = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
      HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
      HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
      HOMEBREW_PIP_INDEX_URL   = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
    };

    brews = [
      "docker"
      "docker-compose"
      "gcc"
      "pi-coding-agent"
    ];

    casks = [
      "wechat"
      "qq"
      "google-chrome"
      "zotero"
      "tencent-meeting"
      "feishu"
      "kitty"
      "zed"
      "visual-studio-code"
      "the-unarchiver"
      "appcleaner"
      "tailscale-app"
      "secretive"
    ];
  };
}
