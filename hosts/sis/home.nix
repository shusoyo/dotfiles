{ inputs, config, ... }: {

  imports = [
    ../general/home.nix
  ];

  modules = {
    shell = {
      fish.shellProxy = "7890";
    };
  };
}
