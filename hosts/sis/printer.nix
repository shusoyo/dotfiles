{ pkgs, ... }: {

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
    enable          = true;
    drivers         = [ pkgs.hplipWithPlugin ];

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
    ensureDefaultPrinter = "p1106";

    ensurePrinters = [
      {
        name       = "p1106";
        location   = "Home";
        deviceUri  = "hp:/usb/HP_LaserJet_Professional_P1106?serial=000000000QNBJ3P2PR1a";
        model      = "HP/hp-laserjet_professional_p1106.ppd.gz";
        ppdOptions = {
          PageSize = "A4";
        };
      }
    ];
  };
}
