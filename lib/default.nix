{ lib, username, system, self, hostname, ... }:

let
  id      = import ./id.nix { inherit self username system hostname; };
  modules = import ./modules.nix { inherit lib; };
in
  id // modules
