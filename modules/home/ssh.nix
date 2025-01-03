{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.file."/.ssh" = {
      source = "${ss.config-path}/ssh";
      recursive = true;
    };
  };
}
