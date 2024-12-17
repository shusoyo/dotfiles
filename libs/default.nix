{lib, infos, homecfg, ...}: 

let
  inherit (lib) mkOption types;
in

rec {
  inherit (infos) username system;

  homeDirectory =
    (if system == "x86_64-darwin" then 
      "/Users/"
    else "/home/") + username;

  flakePath =
    "${homecfg.home.homeDirectory}/soso/home-manager";
  
  configDir =
    "${flakePath}/config";

  symlink = src:
    homecfg.lib.file.mkOutOfStoreSymlink "${src}";

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
