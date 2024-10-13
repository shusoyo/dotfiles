{config, ...}: {
  
  lib.tools = {
    symlink = src:
      config.lib.file.mkOutOfStoreSymlink "${src}";

    flakePath =  
      "${config.home.homeDirectory}/home-manager";
  };
}
