{ pkgs, config, ... }: {

  # Don't need open Firewall because no firewall on lan.

  # Mdns
  # ------------------------------------------------------------------------------
  services.mdns = {
    enable = true;
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
    "d /media/hdd/share/tmpfiles 0755 root root 1d"
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

  # WebDav
  # -----------------------------------------------------------------------------
  services.webdav = {
    enable = true;
    settings = {
      address = "0.0.0.0";
      port = 5825;
      directory = "/home/typer/mirage";
      permissions = "RC";
      users = [
        {
          username = "suspen";
          password = "1202";
          permissions = "CRUD";
        }
      ];
    };
  };

  services.samba = {
    enable = true;
    openFirewall = true;
    settings = {
      global = {
        "workgroup"     = "WORKGROUP";
        "server string" = "smbnix";
        "netbios name"  = "smbnix";
        "security"      = "user";
        "hosts allow"   = "192.168.0. 127.0.0.1 localhost 0.0.0.0/0";
        "guest account" = "nobody";
        "map to guest"  = "bad user";
      };
      "sis" = {
        "path"               = "/home/typer/mirage";
        "read only"          = "no";
        "writable"           = "yes";
        "create mask"        = "0777";
        "directory mask"     = "0777";
        "force user"         = "typer";
        "fruit:aapl"         = "yes";
        "fruit:time machine" = "yes";
        "vfs objects"        = "catia fruit streams_xattr";
      };
    };
  };

  services.tailscale = {
    enable = true;
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
