{ inputs, config, lib, pkgs, ... }: {

  imports = [
    ../general/system.nix
    ./hardware-configuration.nix
  ];

  modules.home-manager.enable = true;
  home-manager = {
    users.mirage = import ./home.nix;
  };

  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
  };

  fonts.fontconfig.enable = false;

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone      = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  services.openssh.enable = true;
  users.users.mirage = {
    home         = "/home/mirage";
    shell        = pkgs.fish;
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/"
    ];
  };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;
  };

  environment.systemPackages = [
    pkgs.sops
    pkgs.age
    pkgs.vim
    pkgs.wget
  ];

  networking.hostName    = "camel";
  networking.useNetworkd = true;
  networking.useDHCP     = false;

  systemd.network.enable = true;
  systemd.network.networks.ethernet = {
    matchConfig.Name = "enp0s1";
    DHCP = "yes";
    networkConfig = {
      IPv6AcceptRA          = "yes";
      KeepConfiguration     = "yes";
      IPv6PrivacyExtensions = "no";
    };
  };

  documentation.man.generateCaches = lib.mkForce false;

  system.stateVersion = "25.05";
}
