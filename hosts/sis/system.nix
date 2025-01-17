{ inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    ../general/system.nix
    ./hardware.nix
    ./services.nix

    inputs.disko.nixosModules.disko
  ];

  # Modules options first
  # ------------------------------------------------------
  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
  };

  modules.home-manager.enable = true;
  home-manager = {
    users.typer = import ./home.nix;
  };

  # Networking
  # ------------------------------------------------------
  networking.hostName    = "sis";
  networking.useDHCP     = false;
  networking.useNetworkd = true;

  networking.firewall = {
    enable = true;

    interfaces."enp1s0" = {
      allowedUDPPorts = [ 67 53 ];
      allowedTCPPorts = [ 80 443 9090 ];
    };
  };

  systemd.network.enable   = true;
  systemd.network.networks = {
    "50-usb-RNDIS" = {
      matchConfig.Name = "enp0s20f0*";
      DHCP = "yes";
      dns  = [ "8.8.8.8" ];
      dhcpV4Config = {
        RouteMetric = 100;
      };
    };

    "10-enp1s0" = {
      matchConfig.Name = "enp1s0";
      address = [
        "10.85.13.10/25"
      ];
      routes  = [
        { Gateway = "10.85.13.1"; Metric = 300; }
      ];
    };
  };

  # users
  # ------------------------------------------------------
  users.users = let
    ssh-keys = with ss.ssh-id; [ ss0 ss1 ms0 ];
  in {
    typer = {
      home         = "/home/typer";
      shell        = pkgs.fish;
      isNormalUser = true;
      extraGroups  = [ "wheel" ];

      openssh.authorizedKeys.keys = ssh-keys;
    };

    root = {
      shell = pkgs.fish;
      openssh.authorizedKeys.keys = ssh-keys;
    };
  };

  environment.systemPackages = [
    pkgs.curl
    pkgs.vim
    pkgs.wget
    pkgs.gitMinimal
    pkgs.mtr
  ];

  boot.loader.systemd-boot.enable      = true;
  boot.loader.efi.canTouchEfiVariables = true;

  system.stateVersion = "25.05";
}
