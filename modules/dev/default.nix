{ lib, config, ss, ... }:

with lib;

let
  cfg = config.modules.dev;
in {

  imports = [
    ./rust.nix
    ./ocaml.nix
    ./python.nix
    # ./cc.nix
    ./go.nix
    ./node.nix
    ./typst.nix
  ];

  options.modules.dev = {
    xdg.enable = ss.mkBoolOpt config.modules.xdg.enable;
  };

  config = mkIf cfg.xdg.enable {
    # TODO
  };
}
