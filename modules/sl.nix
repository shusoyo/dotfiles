{ self, ss, lib, config, ... }: 

let
  cfg = config.sl;
  inherit (config.lib.file) mkOutOfStoreSymlink;
in {
  options.sl = ss.mkOpt lib.types.attrs {};

  config.sl = {
    symlink-to-config = path:
      mkOutOfStoreSymlink "${ss.configDir}/${path}";

    inherit (config.xdg)  configHome cacheHome dataHome stateHome;
    inherit (config.home) homeDirectory;
  };
}
