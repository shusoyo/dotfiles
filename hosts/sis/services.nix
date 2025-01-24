{ pkgs, config, ... }: {

  # Don't need open Firewall because no firewall on lan.

  # Mdns
  # ------------------------------------------------------------------------------
  services.avahi = {
    enable       = true;
    nssmdns4     = true;
    openFirewall = true;

    publish = {
      enable       = true;
      userServices = true;
    };
  };

  # Printer (HP LaserJet_Professional P1106 at sis2, 333)
  # ------------------------------------------------------------------------------
  services.printing = {
    enable  = true;
    drivers = [ pkgs.hplipWithPlugin ];

    listenAddresses = [ "*:631" ];
    allowFrom       = [ "all" ];
    browsing        = true;
    defaultShared   = true;
    openFirewall    = true;

    extraConf = ''
      DefaultEncryption Never
    '';
  };

  # Internet sharing
  # ------------------------------------------------------------------------------
  networking.nftables = {
    enable = true;
    rulesetFile = ./asserts/ruleset.nft;
  };

  systemd.network.networks."10-enp1s0" = {
    matchConfig.Name = "enp1s0";

    address = [ "10.85.13.10/25" ];

    routes  = [
      { Gateway = "10.85.13.1"; Metric = 300; }
    ];

    networkConfig = {
      DHCPServer = "yes";
    };

    dhcpServerConfig = {
      ServerAddress = "10.0.0.1/24";
      PoolOffset = 20;
      PoolSize   = 30;
    };

    dhcpServerStaticLeases = [
      # ap
      { MACAddress = "5c:02:14:9e:d6:dd"; Address = "10.0.0.2";  }
      # ss
      { MACAddress = "00:e2:69:6e:2c:ed"; Address = "10.0.0.10"; }
    ];
  };

  # Mihomo
  # ------------------------------------------------------------------------------
  sops.secrets.abyss-url = {};

  sops.templates."mihomo-config.yaml".restartUnits = [ "mihomo.service" ];
  sops.templates."mihomo-config.yaml".content = ''
    ${builtins.readFile ./asserts/clash-config.yaml}
    proxy-providers:
      abyss:
        type: http
        url: "${config.sops.placeholder.abyss-url}"
        path: ./abyss.yaml
        interval: 86400
  '';

  services.mihomo = {
    enable     = true;
    webui      = pkgs.metacubexd;
    tunMode    = false;
    configFile = config.sops.templates."mihomo-config.yaml".path;
  };

  # Syncthing
  # ------------------------------------------------------------------------------
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
  };

  # Miniflux
  # ------------------------------------------------------------------------------
  sops.secrets.miniflux = {};

  services.miniflux = {
    enable = true;
    adminCredentialsFile = "${config.sops.secrets.miniflux.path}";
    config = {
      LISTEN_ADDR = "0.0.0.0:8070";
    };
  };
}
