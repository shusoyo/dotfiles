{ lib, info, self, ... }:

let
  inherit (lib) mkOption types;
in rec {
  inherit (info) username system;

  homeDirectory =
    (if system == "x86_64-darwin" then
      "/Users/"
    else "/home/") + username;

  flakePath = "${homeDirectory}/.config/home-manager";

  configDir  = "${flakePath}/config";
  configDir' = "${self}/config";

  mkOpt  = type: default:
    mkOption { inherit type default; };

  mkOpt' = type: default: description:
    mkOption { inherit type default description; };

  mkBoolOpt = default: mkOption {
    inherit default;
    type = types.bool;
    example = true;
  };
}
