{ ss, lib, config, ... }:

let
  cfg = config.modules.ssh;
in {
  options.modules.ssh = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    sops.secrets = {
      hws.sopsFile = ./secrets.yaml;
      cts.sopsFile = ./secrets.yaml;
    };

    sops.templates.ssh-config.content = ''
      Host github.com
        AddKeysToAgent yes
        IdentityFile ~/.ssh/id_ed25519

      Host mirage
        HostName camel.local
        User mirage
        IdentityFile ~/.ssh/id_ed25519

      Host hwc
        HostName ${config.sops.placeholder.hws}
        User root
        IdentityFile ~/.ssh/id_ed25519

      Host cts
        HostName ${config.sops.placeholder.cts}
        User root
        IdentityFile ~/.ssh/id_ed25519

      Host typer
        HostName 10.85.13.10
        User typer
        IdentityFile ~/.ssh/id_ed25519
    '';

    sops.templates.ssh-config.path = "${config.home.homeDirectory}/.ssh/config";
  };
}
