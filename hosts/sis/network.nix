{ config, ... }: {
  # Networking
  # ------------------------------------------------------
  networking = {
    useDHCP     = false;
    useNetworkd = true;

    firewall.enable = false; # No local firewall

    hosts = {
      "10.0.0.1" = [ "homepage.lan" "shared.lan" "printer.lan" ];
    };
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

    networks."50-usb-RNDIS" = {
      name = "enp0s20f0*";
      DHCP = "yes";
      dhcpV4Config = {
        RouteMetric = 128;
      };
    };

    networks."30-enp1s0" = {
      name = "enp1s0";
      DHCP = "yes";
    };
  };

  # networking.nftables = {
  #   enable = true;
  #   rulesetFile = ./asserts/ruleset.nft;
  # };
}
