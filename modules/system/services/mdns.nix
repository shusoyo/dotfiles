{ ss, lib, config, pkgs, ... }:

let
  cfg = config.services.mdns;

  mkRecord = address: domains:
    lib.concatMapStringsSep
      " &\n"
      (domain: "${pkgs.avahi}/bin/avahi-publish -a -R ${domain} ${address}")
      domains;
in {
  options.services.mdns = {
    enable  = ss.mkBoolOpt false;
    records = ss.mkOpt (lib.types.attrsOf (lib.types.listOf lib.types.str)) {};
  };

  config = lib.mkIf cfg.enable (lib.mkMerge [
    ({
      services.avahi = {
        enable       = true;
        nssmdns4     = true;
        openFirewall = true;
        reflector    = true;

        publish = {
          enable = true;
          userServices = true;
        };
      };
    })

    (lib.mkIf (cfg.records != {}) {
      systemd.services."avahi-local-records" = {
        after    = [ "avahi-daemon.service" ];
        requires = [ "avahi-daemon.service" ];
        wantedBy = [ "multi-user.target" ];

        script = lib.foldlAttrs (acc: a: d: acc + mkRecord a d) "set -eu\n" cfg.records;

        serviceConfig = {
          Type       = "simple";
          Restart    = "always";
          RestartSec = 3;
        };
      };
    })
  ]);
}
