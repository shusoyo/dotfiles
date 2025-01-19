{ lib, pkgs, ... }: {

  imports = [
    ../../modules/system
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

  documentation = {
    man.generateCaches = lib.mkForce false;
  };
}
