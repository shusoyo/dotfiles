{ pkgs, lib, ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
    ../../modules/system/darwin-home-manager.nix
  ];

# Modules options first
# --------------------------------------------------------------------
  modules.home-manager.enable = true;
  home-manager = {
    users.suspen = import ./home.nix;
  };

# Host/Users
# --------------------------------------------------------------------
  networking.hostName = "shu";

  users.users."suspen"= {
    home = "/Users/suspen";
  };

#  determine.sys
# --------------------------------------------------------------------
  nix.enable = false;

  environment.etc."nix/nix.custom.conf".text = ''
    warn-dirty = false
    use-xdg-base-directories = true
    trusted-users = suspen root
    builders-use-substitutes = true
    substituters = https://cache.nixos.org
    auto-optimise-store = true
  '';

  launchd.daemons.nix-gc = {
    command = "/nix/var/nix/profiles/default/bin/nix-collect-garbage --delete-older-than 4d";
    serviceConfig.RunAtLoad = false;
    serviceConfig.StartCalendarInterval = [{ Weekday = 7; Hour = 3; Minute = 15; }];
  };

  nixpkgs.config.allowUnfree = true;

# Nix
# --------------------------------------------------------------------
  environment.profiles = lib.mkForce (lib.mkOrder 801 [
    "/nix/var/nix/profiles/default"
    "/run/current-system/sw"
    "/etc/profiles/per-user/suspen"
    "$HOME/.local/state/nix/profile"
  ]);

# Systems settings / Profiles
# --------------------------------------------------------------------

  security.pam.services.sudo_local.touchIdAuth = true;

  system.primaryUser = "suspen";
  system = {
    stateVersion = 6;

    # Reload and apply to the current session
    # activationScripts.postUserActivation.text = ''
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    defaults = {
      dock.autohide   = true;
      dock.mru-spaces = false;

      NSGlobalDomain = {
        ApplePressAndHoldEnabled = false;  # enable press and hold
      };
    };
  };

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

  # environment.variables = rec {
  #   # SSH_AUTH_SOCK = "/Users/suspen/.bitwarden-ssh-agent.sock";
  # };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;

    shellInit = ''
      # eval (/usr/libexec/path_helper -c)
    '';
  };
}
