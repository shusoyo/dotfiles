{ inputs, config, ... }: {

  imports = [
    ../general/home.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = [ "${config.xdg.configHome}/sops/age/keys.txt" ];
  };
}
