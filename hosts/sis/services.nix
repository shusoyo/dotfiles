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
}
