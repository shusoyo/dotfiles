{ inputs, config, lib, pkgs, ... }: {

  imports = [
    ../general/system.nix
    ./disk.nix
    ./hardware.nix

    inputs.disko.nixosModules.disko
    inputs.home-manager.nixosModules.home-manager {
      home-manager.users.goose      = import ./home.nix;
      home-manager.useGlobalPkgs   = true;
      home-manager.useUserPackages = true;
    }
  ];

  services.openssh.enable = true;

  environment.systemPackages = map lib.lowPrio [
    pkgs.curl
    pkgs.vim
    pkgs.wget
    pkgs.gitMinimal
  ];

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  networking.hostName = "snowgoose";
  # networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.root = {
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ10Z63y5BH9a2rrW2tDVKBZkAYc84SLMOBcE7EsWFHG"
    ];
  };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.goose = {
    home         = "/home/goose";
    shell        = pkgs.fish;
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ10Z63y5BH9a2rrW2tDVKBZkAYc84SLMOBcE7EsWFHG"
    ];
  };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;
  };

  system.stateVersion = "25.05";
}
