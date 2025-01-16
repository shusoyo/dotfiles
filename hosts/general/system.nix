{ lib, ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
    ../../modules/system/sops.nix
    ../../modules/system/home-manager.nix
  ];

  modules = {
    nix-nixpkgs-settings.enable = true;
  };

  services.openssh.enable = true;

  programs.command-not-found.enable = false;
  documentation.man.generateCaches  = lib.mkForce false;
}
