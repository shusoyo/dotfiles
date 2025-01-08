{ ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
    ../../modules/system/sops.nix
    ../../modules/system/home-manager.nix
  ];

  modules = {
    nix-nixpkgs-settings.enable = true;
  };
}
