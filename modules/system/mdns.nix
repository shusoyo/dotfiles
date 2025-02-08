{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.mdns;

  publish-script = pkgs.writeShellScript "avahi-publish-records.sh" (
    lib.concatMapStringsSep
      " & \n"
      (domain: "${pkgs.avahi}/bin/avahi-publish -a -R ${domain}.local 10.0.0.1")
      cfg.records
  );
in {
  options.modules.mdns = {
    enable  = ss.mkBoolOpt false;
    records = ss.mkOpt (lib.types.listOf lib.types.str) [];
  };

  config = lib.mkIf cfg.enable {
    services.avahi = {
      enable       = true;
      nssmdns4     = true;
      openFirewall = true;

      publish = {
        enable = true;
        userServices = true;
      };
    };

    systemd.services."avahi-local-records" =  {
      after       = [ "avahi-daemon.service" ];
      requires    = [ "avahi-daemon.service" ];
      wantedBy    = [ "multi-user.target" ];

      serviceConfig = {
        Type       = "simple";
        ExecStart  = "${publish-script}";
        Restart    = "always";
        RestartSec = 3;
      };
    };
  };
}
