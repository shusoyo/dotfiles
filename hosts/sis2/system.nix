{ ss, inputs, config, lib, pkgs, ... }: {

  imports = [
    ../general/system.nix
    inputs.wsl.nixosModules.default
  ];

  wsl.enable = true;

  modules.home-manager.enable = true;
  home-manager = {
    users.printer = import ./home.nix;
  };

  time.timeZone      = "Asia/Shanghai";
  i18n.defaultLocale = "en_US.UTF-8";

  networking.hostName    = "sis2";
  networking.useNetworkd = true;
  networking.useDHCP     = false;

  systemd.network.enable = true;
  systemd.network.networks.ethernet = {
    matchConfig.Name = "eth0";
    DHCP = "yes";
    networkConfig = {
      KeepConfiguration     = "yes";
      IPv6AcceptRA          = "yes";
      IPv6PrivacyExtensions = "no";
    };
  };

  services.openssh.enable = true;

  users.users = let
    ssh-keys = with ss.ssh-id; [ ss0 ss1 ms0 ]:
  in {
    printer = {
      home         = "/home/printer";
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
    pkgs.vim
    pkgs.wget
  ];

  documentation.man.generateCaches = lib.mkForce false;

  system.stateVersion = "25.05";
}
