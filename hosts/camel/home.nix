{ inputs, config, ... }: {

  imports = [
    ../prelude/home.nix
  ];

  modules = {
    ssh.enable  = true;
    sops.enable = true;
  };
}
