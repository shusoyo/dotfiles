{ pkgs, lib, ... }: {

  ## Host/Users
  networking.hostName = "ss";

  users.users."suspen"= {
    home = "/Users/suspen";
  };
  # ---------------------- 

  ## Nix
  nix.package = pkgs.nix;

  environment.profiles = lib.mkOrder 801 [
    "$XDG_STATE_HOME/nix/profile"
    "$HOME/.local/state/nix/profile"
  ];

  nix = {
    optimise.automatic = false;
    gc.automatic = true;
    gc.options   = "--delete-older-than 7d";

    settings = {
      trusted-users = [ "suspen" ];
      warn-dirty = false;
      use-xdg-base-directories = true;
      experimental-features = ["nix-command" "flakes"];
      builders-use-substitutes = true;
      substituters = [
        "https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
      ];
    };
  };

  nixpkgs.config.allowUnfree = true;

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;
  # ---------------------- 

  ## Systems
  system = {
    stateVersion = 5;

    # Reload and apply to the current session
    activationScripts.postUserActivation.text = ''
      /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    '';

    defaults = {
      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;  # enable press and hold
      };
    };
  };

  time.timeZone = "Asia/Shanghai";
  
  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable = true;
    useBabelfish = true;
    shellInit = ''
      eval (/usr/libexec/path_helper -c)
    '';
  };
  # ------------------------
}
