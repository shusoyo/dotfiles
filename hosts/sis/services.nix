{ pkgs, config, ... }: {

  # Don't need open Firewall because no firewall on lan.

  # Mdns
  # ------------------------------------------------------------------------------
  services.mdns = {
    enable = true;
    records."10.0.0.1" = [
      "rss.sis.local"
      "home.sis.local"
      "share.sis.local"
      "printer.sis.local"
    ];
  };

  # Homepage
  # ------------------------------------------------------------------------------
  services.caddy.virtualHosts."http://home.sis.local".extraConfig = ''
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

  services.caddy.virtualHosts."http://printer.sis.local".extraConfig = ''
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
  services.simple-http-server = {
    enable = true;
    apps."hdd-file-sharing" = {
      port      = 12345;
      path      = "/media/hdd/share/";
      extraArgs = "-u -l 85899345920"; # 10 GiB
    };
  };

  # tmpfiles to share temporary files
  systemd.tmpfiles.rules = [
    "d /media/hdd/share/tmpfiles 0755 root root 7d"
  ];

  services.caddy.virtualHosts."http://share.sis.local".extraConfig = ''
    reverse_proxy http://localhost:12345
  '';

  # Miniflux
  # ------------------------------------------------------------------------------
  sops.secrets.miniflux = {};

  services.miniflux = {
    enable = true;
    adminCredentialsFile = "${config.sops.secrets.miniflux.path}";
    config.LISTEN_ADDR   = "0.0.0.0:8070";
  };

  services.caddy.virtualHosts."http://rss.sis.local".extraConfig = ''
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
