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

      Host hws
        HostName ${config.sops.placeholder.hws}
        User root
        # IdentityFile ~/.ssh/id_ed25519

      Host cts
        HostName ${config.sops.placeholder.cts}
        User root
        # IdentityFile ~/.ssh/id_ed25519

      Host sis
        HostName sis.local
        User typer
        # IdentityFile ~/.ssh/id_ed25519

      Host debian
        HostName 192.168.64.2
        User suspen
        # IdentityFile ~/.ssh/id_ed25519

      Host cs162
        HostName 127.0.0.1
        Port 16222
        User workspace
        IdentityFile ~/.ssh/id_ed25519
    '';

    sops.templates.ssh-config.path = "${config.home.homeDirectory}/.ssh/config";
  };
}
