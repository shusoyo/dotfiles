{ ss, lib, config, options, pkgs, ... }:

with lib;
let
  cfg = config.home;
in {
  imports = [
    ss.modules.hjem.default
  ];

  options.home = with types; {
    file        = mkOpt' attrs {} "Files to place directly in $HOME";
    configFile  = mkOpt' attrs {} "Files to place in $XDG_CONFIG_HOME";
    dataFile    = mkOpt' attrs {} "Files to place in $XDG_DATA_HOME";

    sessionPath      = mkOpt' (listOf (either str path)) [] "Extra directories in PATH";
    sessionVariables = mkOpt' attrs {} "Environment variables to set in the user session.";

    dir       = mkOpt str config.users.users.${config.user.name}.home;
    binDir    = mkOpt str "${cfg.dir}/.local/bin";
    cacheDir  = mkOpt str "${cfg.dir}/.cache";
    configDir = mkOpt str "${cfg.dir}/.config";
    dataDir   = mkOpt str "${cfg.dir}/.local/share";
    stateDir  = mkOpt str "${cfg.dir}/.local/state";

    flakeDir = mkOpt str "${cfg.dir}/.config/dotfiles";
  };

  config = {
    # System-level XDG environment variables
    environment.variables = {
      XDG_BIN_HOME    = cfg.binDir;
      XDG_CACHE_HOME  = cfg.cacheDir;
      XDG_CONFIG_HOME = cfg.configDir;
      XDG_DATA_HOME   = cfg.dataDir;
      XDG_STATE_HOME  = cfg.stateDir;
    };

    home.sessionPath = [ "${cfg.binDir}" ];

    hjem = {
      clobberByDefault = true;
      users.${config.user.name} = {
        enable = true;
        files  = mkAliasDefinitions options.home.file;

        xdg = {
          config.files = mkAliasDefinitions options.home.configFile;
          data.files   = mkAliasDefinitions options.home.dataFile;

          # Force these, since it'll be considered an abstraction leak to use
          # Hjem's API anywhere outside this module.
          cache.directory  = mkForce cfg.cacheDir;
          config.directory = mkForce cfg.configDir;
          data.directory   = mkForce cfg.dataDir;
          state.directory  = mkForce cfg.stateDir;
        };

        environment.sessionVariables = mkAliasDefinitions options.home.sessionVariables;
      };
    };
  };
}
