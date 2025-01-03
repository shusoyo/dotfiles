{ self, ss, lib, config, ... }:

let
  cfg = config.adhoc;
in {
  options.adhoc = ss.mkOpt lib.types.attrs {};

  config.adhoc = {
    symlink-to-config = path:
      config.lib.file.mkOutOfStoreSymlink "${ss.abs-config-path}/${path}";
  };
}
