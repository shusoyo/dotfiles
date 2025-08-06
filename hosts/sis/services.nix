{ pkgs, config, ... }: {

  # Don't need open Firewall because no firewall on lan.

  # Mdns
  # ------------------------------------------------------------------------------
  services.mdns = {
    enable = true;
    # records = {
    #   "10.0.0.1" = [
    #     "rssfeeder.local"
    #     "homepage.local"
    #     "shared.local"
    #     "printer.local"
    #   ];
    # };
  };

  # Homepage
  # ------------------------------------------------------------------------------
  services.caddy.virtualHosts."http://homepage.lan".extraConfig = ''
    encode gzip
    file_server
    root * ${
      pkgs.runCommand "make-homepage" {} ''
        mkdir "$out"
        echo '{{include "homepage.md" | markdown}}' > "$out/index.html"
        cp ${./asserts/homepage.md} "$out/homepage.md"
      ''
    }
    templates {
      mime .md text/html
    }
  '';

  # Printer (HP LaserJet_Professional P1106 at sis2, 333)
  # ------------------------------------------------------------------------------
  services.printing = {
    enable  = true;
    drivers = [ pkgs.hplipWithPlugin ];

    listenAddresses = [ "*:631" ];
    allowFrom       = [ "all" ];
    browsing        = true;
    defaultShared   = true;

    extraConf = ''
      DefaultEncryption Never
    '';
  };

  services.caddy.virtualHosts."http://printer.lan".extraConfig = ''
    redir http://10.85.13.10:631
  '';

  # Mihomo
  # ------------------------------------------------------------------------------
  sops.secrets.abyss-url = {};

  sops.templates."mihomo-config.yaml".restartUnits = [ "mihomo.service" ];
  sops.templates."mihomo-config.yaml".content = ''
    ${builtins.readFile ./asserts/clash-config.yaml}
    proxy-providers:
      djjc:
        type: http
        url: "${config.sops.placeholder.abyss-url}"
        path: ./djjc.yaml
        interval: 86400
  '';

  services.mihomo = {
    enable     = true;
    webui      = pkgs.metacubexd;
    tunMode    = true;
    configFile = config.sops.templates."mihomo-config.yaml".path;
  };

  # File sharing
  # ------------------------------------------------------------------------------
  services.simple-http-server = {
    enable = true;
    apps."hdd-file-sharing" = {
      port      = 27777;
      path      = "/media/hdd/share/";
      extraArgs = "-u -l 85899345920"; # 10 GiB
    };
  };

  # tmpfiles to share temporary files
  systemd.tmpfiles.rules = [
    "d /media/hdd/share/tmpfiles 0755 root root 7d"
  ];

  services.caddy.virtualHosts."http://shared.lan".extraConfig = ''
    reverse_proxy http://localhost:27777
  '';


  # Miniflux
  # ------------------------------------------------------------------------------
  sops.secrets.miniflux = {};

  services.miniflux = {
    enable = true;
    adminCredentialsFile = "${config.sops.secrets.miniflux.path}";
    config.LISTEN_ADDR   = "0.0.0.0:8070";
  };

  # services.caddy.virtualHosts."http://rssfeeder.local".extraConfig = ''
  #   reverse_proxy http://localhost:8070
  # '';

  # WebDav
  # -----------------------------------------------------------------------------
  services.webdav = {
    enable = true;
    seetings = {
      address = "0.0.0.0";
      port = 5825;
      scope = "/media/hdd/webdav";
      modify = true;
      auth = true;
      users = [
        {
          username = "suspen";
          password = "1202";
        }
      ];
    };
  };

  # Caddy
  # -----------------------------------------------------------------------------
  services.caddy = {
    enable = true;
    # Local area network
    globalConfig = ''
      auto_https off
    '';
  };
}
