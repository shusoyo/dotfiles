{ lib, ... }:

lib.extend (self: super:
  let
    modules = import ./modules.nix { lib = self; };
    system  = import ./system.nix  { lib = self; };
  in
    modules // system
)
