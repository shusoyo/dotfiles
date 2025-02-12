{ ss, lib, config, pkgs, ... }:

let
  cfg = config.services.mdns;
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

        publish = {
          enable = true;
          userServices = true;
        };
      };
    })

    (lib.mkIf (cfg.records != {}) {
      systemd.services."avahi-local-records" = let
        makeRecord = address: domains:
          lib.concatMapStringsSep " &\n"
            (domain: "${pkgs.avahi}/bin/avahi-publish -a -R ${domain} ${address}")
            domains;
        publish-script = pkgs.writeShellScript "avahi-publish-records.sh" (
          lib.foldlAttrs (acc: n: v: acc + makeRecord n v) "" cfg.records
        );
      in {
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
    })
  ]);
}
