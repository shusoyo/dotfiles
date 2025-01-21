{ inputs, config, lib, ss, ... }:

let
  cfg = config.modules.sops;
in {
  imports = [ inputs.sops-nix.nixosModules.sops ];

  options.modules.sops = {
    enable   = ss.mkBoolOpt false;
    sopsFile = ss.mkOpt (lib.types.nullOr lib.types.path) null;
  };

  config = lib.mkIf cfg.enable {
    sops = {
      gnupg.sshKeyPaths = [];
      age.sshKeyPaths   = [];
      age.keyFile       = "/var/lib/sops-nix/key.txt";
      defaultSopsFile   = cfg.sopsFile;
    };
  };
}
