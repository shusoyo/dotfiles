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
  networking = {
    hostName        = "sis";
    useNetworkd     = true;
    useDHCP         = false;
    firewall.enable = false;
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

      networkConfig = {
        DHCPServer = "yes";
      };
      dhcpServerConfig = {
        ServerAddress = "10.85.13.10/25";
        PoolOffset = 2;
        PoolSize   = 20;
      };
      dhcpServerStaticLeases = [
        { MACAddress = "00:e2:69:6e:2c:ed"; Address = "10.85.13.29"; }
      ];
    };
  };

#   networking.firewall.extraCommands = ''
#     # Set up SNAT on packets going from downstream to the wider internet
#     iptables -t nat -A POSTROUTING -o enp0s20f0u2 -j MASQUERADE
#
#     # Accept all connections from downstream. May not be necessary
#     iptables -A INPUT -i enp1s0 -j ACCEPT
#   '';

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

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;
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

  time.timeZone      = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  system.stateVersion = "25.05";
}
