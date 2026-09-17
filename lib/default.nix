{ lib, ... }:

let
  modules = import ./modules.nix { inherit lib; };
  options = import ./options.nix { inherit lib; };
  system  = import ./system.nix { inherit lib; };
  keys    = { ssh-id = import ./keys.nix; };
in
  modules // options // system // keys
