{ ss, lib, config, pkgs, ... }:

let
  cfg = config.services.simple-http-server;

  per-server-opt = lib.types.submodule {
    options = {
      port      = ss.mkOpt lib.types.int 0;
      path      = ss.mkOpt lib.types.str null;
      extraArgs = ss.mkOpt lib.types.str "";
    };
  };

  all-apps = lib.mapAttrs (n: sOpts: {
    after    = [ "network.target" ];
    wantedBy = [ "default.target" ];

    serviceConfig = {
      Type      = "simple";
      Restart   = "always";
      ExecStart = ''
        ${pkgs.simple-http-server}/bin/simple-http-server \
          -i -p ${builtins.toString sOpts.port} \
          ${sOpts.extraArgs} \
          ${sOpts.path}
      '';
    };
  }) cfg.apps;
in {
  options.services.simple-http-server = {
    enable = ss.mkBoolOpt false;
    apps   = ss.mkOpt (lib.types.attrsOf per-server-opt) {};
  };

  config = lib.mkIf cfg.enable {
    systemd.services = all-apps;
  };
}
