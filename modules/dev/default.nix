{ lib, config, options, pkgs, ... }:

with lib;

let 
  cfg = config.modules.dev;
in {

  imports = [
    ./rust.nix
    ./ocaml.nix
    ./python.nix
    ./cc.nix
  ];

  options.modules.dev = {
    xdg.enable = mkOption { type = types.bool; default = config.xdg.enable; }; 
  };

  config = mkIf cfg.xdg.enable {
    # TODO
  };
}
