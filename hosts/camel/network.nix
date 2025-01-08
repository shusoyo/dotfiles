{

  networking.hostName = "camel";
  networking.useNetworkd = true;
  networking.useDHCP     = false;

  systemd.network.enable = true;
  systemd.network.networks.ethernet = {
    matchConfig.Name = "enp0s1";
    DHCP = "yes";
    networkConfig = {
      KeepConfiguration = "yes";
      IPv6AcceptRA = "yes";
      IPv6PrivacyExtensions = "no";
    };
  };

  # networking.firewall.allowedUDPPorts = [ 51820 ];
  networking.useNetworkd = true;

  # systemd.network.netdevs = {
  #   "50-wg0" = {
  #     netdevConfig = {
  #       Kind = "wireguard";
  #       Name = "wg0";
  #       MTUBytes = "1420";
  #     };
  #     wireguardConfig = {
  #       PrivateKeyFile = "/home/mirage/sahara/wg_keys/private_key";
  #       ListenPort = 51820;
  #       # RouteTable = "main"; # wg-quick creates routing entries automatically but we must use use this option in systemd.
  #     };
  #     wireguardPeers = [
  #       {
  #         PublicKey = "37yMGl/f449DeGGYL2h02CeFzyRRKtNe1gqhHuY9+GI=";
  #         AllowedIPs = ["10.10.0.2"];
  #       }
  #     ];
  #   };
  # };
  #
  # systemd.network.networks.wg0 = {
  #   matchConfig.Name = "wg0";
  #   address = ["10.10.0.1/32"];
  #   networkConfig = {
  #     IPMasquerade = "ipv4";
  #     IPForward = true;
  #   };
  # };
}
