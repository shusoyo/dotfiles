{ ss, lib, config, ... }:

let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    services.openssh = {
      enable = true;
      settings.PermitRootLogin              = "yes";
      settings.PasswordAuthentication       = false;
      settings.KbdInteractiveAuthentication = false;
    };
  };
}
