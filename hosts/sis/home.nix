{ inputs, config, ... }: {

  imports = [
    ../prelude/home.nix
  ];

  modules = {
    shell = {
      fish.shellProxy = "7890";
    };
  };
}
