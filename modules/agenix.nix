{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.agenix;
in {
  options.modules.agenix = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    home.file."/.ssh" = {
      source = ../config/ssh;
      recursive = true;
    };
  };
}
