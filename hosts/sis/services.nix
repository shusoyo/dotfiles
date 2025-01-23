{ pkgs, config, ... }: {

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

  ## p1106 setup using hp-setup
  # hardware.printers = {
  #   ensureDefaultPrinter = "HP_laserjet_P1106";
  #
  #   ensurePrinters = [{
  #     name       = "HP_laserjet_P1106";
  #     location   = "sis";
  #     deviceUri  = "hp:/usb/HP_LaserJet_Professional_P1106?serial=000000000QNBJ3P2PR1a";
  #     model      = "drv:///hp/hpcups.drv/hp-laserjet_professional_p1106.ppd";
  #     ppdOptions = { PageSize = "A4"; };
  #   }];
  # };

  # Internet sharing
  # ------------------------------------------------------------------------------
  networking.firewall.extraCommands = ''
    iptables -t nat -A POSTROUTING -o enp0s20f0u5 -j MASQUERADE
    iptables -A INPUT -i enp1s0 -j ACCEPT
  '';

  systemd.network.networks."10-enp1s0" = {
    matchConfig.Name = "enp1s0";

    address = [ "10.85.13.10/25" ];

    networkConfig = {
      DHCPServer = "yes";
    };

    dhcpServerConfig = {
      ServerAddress = "10.0.0.1/24";
      PoolOffset = 20;
      PoolSize   = 30;
    };

    dhcpServerStaticLeases = [
      { MACAddress = "5c:02:14:9e:d6:dd"; Address = "10.0.0.2";  }
      { MACAddress = "00:e2:69:6e:2c:ed"; Address = "10.0.0.10"; }
      { MACAddress = "0a:3b:a0:25:1c:f5"; Address = "10.0.0.11"; }
    ];
  };

  # Mihomo
  # ------------------------------------------------------------------------------
  sops.secrets.abyss-url = {};

  sops.templates."mihomo-config.yaml".restartUnits = [ "mihomo.service" ];
  sops.templates."mihomo-config.yaml".content = ''
    ${builtins.readFile ./clash-config.yaml}
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
