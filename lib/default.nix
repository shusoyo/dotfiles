{ lib, info, self, ... }:

let
  inherit (lib) mkOption types;
  inherit (self.outputs.homeConfigurations."${info.username}".config.lib.file) mkOutOfStoreSymlink;
in rec {
  inherit (info) username system;

  homeDirectory =
    (if system == "x86_64-darwin" then
      "/Users/"
    else "/home/") + username;

  flakePath = "${homeDirectory}/.config/home-manager";

  configDir  = "${flakePath}/config";
  configDir' = "${self}/config";

  cfgSymLink = src:
    mkOutOfStoreSymlink "${configDir}/${src}";

  symlink = src:
    mkOutOfStoreSymlink "${src}";

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
