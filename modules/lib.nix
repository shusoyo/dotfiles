{config, lib, ...}: with lib; {

  lib.tools = {
    symlink = src:
      config.lib.file.mkOutOfStoreSymlink "${src}";

    flakePath =  
      "${config.home.homeDirectory}/soso/home-manager";

    mkOpt  = type: default:
      mkOption { inherit type default; };

    mkOpt' = type: default: description:
      mkOption { inherit type default description; };

    mkBoolOpt = default: mkOption {
      inherit default;
      type = types.bool;
      example = true;
    };
  };
}
