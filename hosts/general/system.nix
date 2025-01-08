{ ... }: {

  imports = [
    ../../modules/system/nix-nixpkgs-config.nix
  ];

  modules = {
    nix-nixpkgs-settings.enable = true;
  };

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
  ];
}
