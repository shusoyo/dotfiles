{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.no-doc;
in {
  options.modules.no-doc = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    # No doc
    documentation = {
      enable             = lib.mkForce false;
      dev.enable         = lib.mkForce false;
      doc.enable         = lib.mkForce false;
      info.enable        = lib.mkForce false;
      man.enable         = lib.mkForce false;
      nixos.enable       = lib.mkForce false;
      man.man-db.enable  = lib.mkForce false;
      man.generateCaches = lib.mkForce false;
    };
  };
}
