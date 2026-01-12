{ pkgs, lib, ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
    ../../modules/system/darwin-home-manager.nix
  ];

# Modules options first
# --------------------------------------------------------------------
  modules.nix-nixpkgs-settings.enable = true;

  modules.home-manager.enable = true;
  home-manager = {
    users.suspen = import ./home.nix;
  };

# Host/Users
# --------------------------------------------------------------------
  networking.hostName = "ss";

  users.users."suspen"= {
    home = "/Users/suspen";
  };

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
  system.primaryUser = "suspen";
  system = {
    stateVersion = 6;

    # Reload and apply to the current session
    # activationScripts.postUserActivation.text = ''
    #   /System/Library/PrivateFrameworks/SystemAdministration.framework/Resources/activateSettings -u
    # '';

    defaults = {
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

  environment.variables = rec {
    # SSH_AUTH_SOCK = "/Users/suspen/.bitwarden-ssh-agent.sock";
  };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;

    shellInit = ''
      # eval (/usr/libexec/path_helper -c)
    '';
  };
}
