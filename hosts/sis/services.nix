{ pkgs, config, ... }: {

  # Don't need open Firewall because no firewall on lan.

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

  # Syncthing
  # ------------------------------------------------------------------------------
  services.syncthing = {
    enable = true;
    guiAddress = "0.0.0.0:8384";
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
