{ inputs, config, ... }: {

  imports = [
    ../general/home.nix
    inputs.sops-nix.homeManagerModules.sops
  ];

  sops = {
    defaultSopsFile = ./secrets/secrets.yaml;
    age.keyFile = [ "${config.xdg.configHome}/sops/age/keys.txt" ];

    # secrets."ssh-hosts" = {
    #   path = "${config.home.homeDirectory}/.ssh/config.d/ssh-hosts.config";
    # };
  };
}
