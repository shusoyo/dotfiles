{ pkgs, config, ... }: {

  # Don't need open Firewall because no firewall on lan.

  # Mdns
  # ------------------------------------------------------------------------------
  modules.mdns = {
    enable  = true;
    records = [
      "shared"
      "homepage"
      "rss"
      "printer"
    ];
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

  services.caddy.virtualHosts."http://printer.local".extraConfig = ''
    redir http://sis.local:631
  '';

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

  # File sharing
  # ------------------------------------------------------------------------------
  systemd.services.local-file-sharing = {
    after    = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type      = "simple";
      ExecStart = ''
        ${pkgs.simple-http-server}/bin/simple-http-server \
        -i -u -p 12345 \
        -l 1000000000000 \
        /media/hdd/share/
      '';
    };
  };

  systemd.tmpfiles.rules = [
    "d /media/hdd/share/tmpfiles 0755 root root 7d"
  ];

  services.caddy.virtualHosts."http://shared.local".extraConfig = ''
    reverse_proxy http://localhost:12345
  '';

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

  services.caddy.virtualHosts."http://rss.local".extraConfig = ''
    reverse_proxy http://localhost:8070
  '';

  # Caddy
  # -----------------------------------------------------------------------------
  services.caddy = {
    enable = true;
    globalConfig = ''
      auto_https off
    '';
  };
}
