{ pkgs, ... }: {

  # Printer (HP LaserJet_Professional P1106 at sis2, 333)
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

  hardware.printers = {
    ensureDefaultPrinter = "HP_laserjet_P1106";

    ensurePrinters = [
      {
        name       = "HP_laserjet_P1106";
        location   = "sis";
        deviceUri  = "hp:/usb/HP_LaserJet_Professional_P1106?serial=000000000QNBJ3P2PR1a";
        model      = "drv:///hp/hpcups.drv/hp-laserjet_professional_p1106.ppd";
        ppdOptions = { PageSize = "A4"; };
      }
    ];
  };

  # Dnsmasq
  # ------------------------------------------------------------------------------

  # networking.firewall.extraCommands = ''
  #   # Set up SNAT on packets going from downstream to the wider internet
  #   iptables -t nat -A POSTROUTING -o enp0s20f0u2 -j MASQUERADE
  #
  #   # Accept all connections from downstream. May not be necessary
  #   iptables -A INPUT -i enp1s0 -j ACCEPT
  # '';

  services.dnsmasq = {
    enable = true;
    settings = {
      interface = "enp1s0";

      bind-interfaces    = true;
      dhcp-authoritative = true;

      dhcp-host = [
        "00:e2:69:6e:2c:ed,10.85.13.20"
      ];

      dhcp-option = [
        "option:router,10.85.13.10"
      ];

      dhcp-range = [
        "10.85.13.40,10.85.13.90,24h"
      ];
    };
  };

  # Mihomo
  # ------------------------------------------------------------------------------
  services.mihomo = {
    enable     = true;
    webui      = pkgs.metacubexd;
    configFile = ./config.yaml;
  };
}
