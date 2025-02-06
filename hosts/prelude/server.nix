{ lib, pkgs, ... }: {

  imports = [
    ./general.nix
  ];

  modules = {
    no-doc.enable = true;
  };
}
