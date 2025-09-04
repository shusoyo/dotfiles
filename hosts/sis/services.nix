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
    user  = "typer";
    settings = {
      address = "0.0.0.0";
      port = 5825;
      directory = "/home/typer/syncthing/";
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
        "path"               = "/home/typer/syncthing/";
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

  # services.tailscale = {
  #   enable = true;
  # };

  services.syncthing = {
    enable = true;
    dataDir = "/home/typer/";
    configDir = "/home/typer/.config/syncthing";
    user = "typer";
    group = "users";
    guiAddress = "0.0.0.0:8384";
    settings = {
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
      };
      # gui = {
      #   user = "suspen";
      #   password = "1202";
      # };
      devices = {
        "ss_iphone" = { id = "6D52CQG-JXIWTKB-QFDIRSH-7TFSQVS-OXWBMLW-R5MPXPO-24WGH2Y-LRBNPQT"; };
        "ss_mac"    = { id = "BCNCYG2-5NI4S2Z-RGNQMKS-ZSXYXFD-C6BNNVO-R2AYWD3-KM5YTQV-YPB3TQT"; };
        "ss_ipad"   = { id = "PJUAYSZ-GZ2VOZR-SMB2ZJL-AYRGQAI-FYXXDGI-TXBAYUI-B4ZVC6Q-RFBDHQI"; };
      };
      folders = {
        "sync" = {
          path = "/home/typer/syncthing/sync";
          devices = [ "ss_iphone" "ss_mac" "ss_ipad" ];
        };
        "backup" = {
          path = "/home/typer/syncthing/backup/";
          devices = [ "ss_mac" ];
        };
      };
    };
  };

  environment.systemPackages = [
    pkgs.openlist
  ];
  systemd.services."openlist" = {
    after    = [ "network.target" ];
    wantedBy = [ "default.target" ];
    #
    # environment = {
    #   DATA_DIR = "/home/typer/.config/openlist";
    # };

    serviceConfig = {
      Type      = "simple";
      Restart   = "on-failure";
      ExecStart = ''
        ${pkgs.openlist}/bin/OpenList --data /etc/openlist server
      '';
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
