{ inputs, config, lib, ss, ... }:

let
  cfg = config.modules.sops;
in {
  imports = [ inputs.sops-nix.homeManagerModules.sops ];

  options.modules.sops = {
    enable   = ss.mkBoolOpt false;
    sopsFile = ss.mkOpt (lib.types.nullOr lib.types.path) null;
  };

  config = lib.mkIf cfg.enable {
    sops = {
      gnupg.sshKeyPaths = [];
      age.sshKeyPaths   = [];
      age.keyFile       = "${config.xdg.configHome}/sops/age/keys.txt";
      defaultSopsFile   = cfg.sopsFile;
    };
  };
}
