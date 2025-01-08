{ lib, username, system, self, ... }:

let
  id      = import ./id.nix { inherit self username system; };
  modules = import ./modules.nix { inherit lib; };
in
  id // modules
