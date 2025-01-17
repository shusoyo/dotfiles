{ ss, lib, config, ... }:

with lib;

let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    sops.secrets."hwc" = {
      sopsFile = ./hosts.yaml;
    };

    sops.templates."hosts.conf".content = ''
      Host github.com
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519

      Host mirage
        HostName 192.168.64.2
        User mirage
        IdentityFile ~/.ssh/id_ed25519

      Host hwc
        HostName ${config.sops.placeholder."hwc"}
        User root
        IdentityFile ~/.ssh/id_ed25519

      Host sis
        HostName 10.85.13.10
        User typer
        IdentityFile ~/.ssh/id_ed25519
    '';

    sops.templates."hosts.conf".path = "${config.home.homeDirectory}/.ssh/hosts.d/hosts.conf";

    home.file."/.ssh" = {
      source = "${ss.config-path}/ssh";
      recursive = true;
    };
  };
}
