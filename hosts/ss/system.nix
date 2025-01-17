{ pkgs, lib, ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
  ];

# Modules options first
# ------------------------------------------------------
  modules.nix-nixpkgs-settings.enable = true;

# Host/Users
# --------------------------------------------------------------------
  networking.hostName = "ss";

  users.users."suspen"= {
    home = "/Users/suspen";
  };

# Nix
# --------------------------------------------------------------------
  environment.profiles = lib.mkForce (lib.mkOrder 801 [
    "/run/current-system/sw"
    "/nix/var/nix/profiles/default"
    "$HOME/.local/state/nix/profile"
  ]);

  # Auto upgrade nix package and the daemon service.
  services.nix-daemon.enable = true;

# Systems settings / Profiles
# --------------------------------------------------------------------
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

  fonts.packages = with pkgs; [
    fira
    nerd-fonts.fira-code
    noto-fonts-cjk-sans
    noto-fonts-cjk-serif
  ];

  time.timeZone = "Asia/Shanghai";

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;

    shellInit = ''
      # eval (/usr/libexec/path_helper -c)
    '';
  };
}
