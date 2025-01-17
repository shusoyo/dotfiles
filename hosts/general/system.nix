{ lib, pkgs, ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
    ../../modules/system/sops.nix
    ../../modules/system/home-manager.nix
  ];

  modules = {
    nix-nixpkgs-settings.enable = true;
  };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;
  };

  services.openssh.enable = true;

  fonts.fontconfig.enable = false;

  time.timeZone      = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  programs.command-not-found.enable = false;
  documentation.man.generateCaches  = lib.mkForce false;
}
