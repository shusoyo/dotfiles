{ inputs, config, lib, pkgs, ss, ... }: {

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

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  users.users.mirage = {
    home         = "/home/mirage";
    shell        = pkgs.fish;
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [ ss.ssh-id.ss0 ];
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

  networking.firewall = {
    enable = true;
    allowedTCPPorts = [ 80 443 9090 ];
  };

  systemd.network.enable   = true;
  systemd.network.networks = {
    "10-enp0s1" = {
      matchConfig.Name = "enp0s1";
      address = [
        "192.168.64.2/24"
      ];
      routes  = [
        { Gateway = "192.168.64.1"; }
      ];
    };
  };

  system.stateVersion = "25.05";
}
