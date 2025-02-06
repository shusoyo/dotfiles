{ lib, pkgs, ss, ... }: {

  imports = [
    ../../modules/system
  ];

  modules = {
    ssh.enable  = true;
    headless.enable = true;
    nix-nixpkgs-settings.enable = true;
  };

  networking.hostName = ss.hostname;

  i18n.defaultLocale = "en_US.UTF-8";

  programs.command-not-found.enable = false;
  documentation.man.generateCaches = lib.mkForce false;

  system.stateVersion = "25.05";
}
