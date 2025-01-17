{ inputs, config, ... }: {

  imports = [
    ../general/home.nix
  ];

  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
  };

  modules = {
    ssh.enable = true;
  };
}
