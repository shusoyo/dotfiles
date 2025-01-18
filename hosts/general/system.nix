{ lib, pkgs, ... }: {

  imports = [
    ../../modules/system/ssh.nix
    ../../modules/system/fish.nix
    ../../modules/system/sops.nix
    ../../modules/system/headless.nix
    ../../modules/system/home-manager.nix
    ../../modules/system/nix-nixpkgs-config.nix
  ];

  modules = {
    nix-nixpkgs-settings.enable = true;

    ssh.enable  = true;

    fish.enable = true;

    headless.enable = true;
  };

  time.timeZone      = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.command-not-found.enable = false;
  documentation.man.generateCaches  = lib.mkForce false;
}
