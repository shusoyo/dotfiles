{ lib, username, system, self, ... }:

rec {
  inherit username system;

  home-path = (
    if system == "x86_64-darwin" then "/Users/" else "/home/"
  ) + username;

  abs-flake-path  = "${home-path}/.config/home-manager";
  abs-config-path = "${abs-flake-path}/config";
  config-path     = "${self}/config";

  mkOpt = type: default:
    lib.mkOption {
      inherit type default;
    };

  mkOpt' = type: default: description:
    lib.mkOption {
      inherit type default description;
    };

  mkBoolOpt = default:
    lib.mkOption {
      inherit default;
      type    = lib.types.bool;
      example = true;
    };
}
