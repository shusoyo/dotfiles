{ config, ... }: {
  # Networking
  # ------------------------------------------------------
  networking = {
    useDHCP     = false;
    useNetworkd = true;

    firewall.enable = false; # No local firewall
  };

  # DNS
  services.resolved = {
    enable  = true;
    domains = [ "~." ];
    fallbackDns = [ "223.5.5.5" "8.8.8.8" ];
    dnsovertls  = "opportunistic";
    extraConfig = ''
      DNSStubListenerExtra=10.0.0.1
      MulticastDNS=no
    '';
  };

  systemd.network = {
    enable = true;

    netdevs."20-br0".netdevConfig = {
      Kind = "bridge";
      Name = "br0";
    };

    networks."50-usb-RNDIS" = {
      name = "enp0s20f0*";
      DHCP = "yes";
      dhcpV4Config = {
        RouteMetric = 128;
      };
    };

    networks."30-enp1s0" = {
      name   = "enp1s0";
      bridge = [ "br0" ];

      linkConfig.RequiredForOnline = "enslaved";
    };

    # Router interface
    networks."40-br0" = {
      name = "br0";

      address = [ "10.85.13.10/25" ];

      networkConfig = {
        DHCPServer = "yes";
      };

      dhcpServerConfig = {
        ServerAddress = "10.0.0.1/24";
        PoolOffset = 30;
        PoolSize = 100;
        DNS = [ "10.0.0.1" ];
      };

      dhcpServerStaticLeases = [
        # ap
        { MACAddress = "5c:02:14:9e:d6:dd"; Address = "10.0.0.2";  }
        # ss
        { MACAddress = "00:e2:69:6e:2c:ed"; Address = "10.0.0.10"; }
      ];
    };
  };

  networking.nftables = {
    enable = true;
    rulesetFile = ./asserts/ruleset.nft;
  };

  # pppoe
  sops.secrets.pppoe-name = {};
  sops.secrets.pppoe-password = {};

  sops.templates.edpnet.restartUnits = [ "pppd-edpnet.service" ];
  sops.templates.edpnet.content = ''
    plugin pppoe.so br0

    name "${config.sops.placeholder.pppoe-name}"
    password "${config.sops.placeholder.pppoe-password}"

    persist

    defaultroute
    defaultroute-metric 256
  '';

  services.pppd = {
    enable = true;
    peers.edpnet = {
      enable    = true;
      autostart = true;
      config    = "file ${config.sops.templates.edpnet.path}";
    };
  };
}
