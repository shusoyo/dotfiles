{ lib, pkgs, ... }: {

  imports = [
    ./general.nix
  ];

  modules = {
    fish.enable = true;
  };

  time.timeZone = "Asia/Shanghai";
}
