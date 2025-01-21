{ inputs, config, ... }: {

  imports = [
    ../general/home.nix
  ];

  modules = {
    ssh.enable  = true;
    sops.enable = true;
  };
}
