{ inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    ../general/system.nix
    ./hardware.nix
    ./services.nix

    inputs.disko.nixosModules.disko
  ];

  services.openssh.enable = true;

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
  networking.useNetworkd = true;
  networking.useDHCP  = false;
  networking.hostName = "sis";

  systemd.network.enable = true;
  systemd.network.networks."50-usb-RNDIS" = {
    matchConfig.Name = "enp0s20f0u2";
    DHCP = "yes";
    dns  = [ "8.8.8.8" ];
    dhcpV4Config = {
      RouteMetric = 100;
    };
  };

  systemd.network.networks."10-enp1s0" = {
    matchConfig.Name = "enp1s0";
    address = [ "10.85.13.10/25" ];
    routes  = [
      { Gateway = "10.85.13.1"; Metric = 300; }
    ];
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

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  programs.command-not-found.enable = false;
  documentation.man.generateCaches = lib.mkForce false;

  system.stateVersion = "25.05";
}
