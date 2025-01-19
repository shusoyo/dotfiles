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

  documentation = {
    enable             = lib.mkForce false;
    dev.enable         = lib.mkForce false;
    doc.enable         = lib.mkForce false;
    info.enable        = lib.mkForce false;
    man.enable         = lib.mkForce false;
    nixos.enable       = lib.mkForce false;
    man.mandoc.enable  = lib.mkForce false;
    man.man-db.enable  = lib.mkForce false;
    man.generateCaches = lib.mkForce false;
  };

  programs.command-not-found.enable = false;
}
