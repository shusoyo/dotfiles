{ lib, config, options, pkgs, ... }:

with lib;
# with config.lib.tools;

let 
  devCfg = config.modules.dev;
  cfg = devCfg.python;
in {
  options.modules.dev.python = {
    enable = config.lib.tools.mkBoolOpt false;
    xdg.enable = config.lib.tools.mkBoolOpt devCfg.xdg.enable;
  };

  config = mkMerge [
    (mkIf cfg.enable {
      home.packages = with pkgs; [
        python3
        # python3Packages.pip
        # python3Packages.ipython
        # python3Packages.black
        # python3Packages.setuptools
        # python3Packages.pylint
        # python3Packages.poetry
      ];
    })

    (mkIf (cfg.xdg.enable && cfg.enable) {
      home.sessionVariables = {
        # Internal
        PYTHONPYCACHEPREFIX = "${config.xdg.cacheHome}/python";
        PYTHONSTARTUP = "${config.xdg.configHome}/python/pythonrc";
        PYTHONUSERBASE = "${config.xdg.dataHome}/python";
        PYTHON_EGG_CACHE = "${config.xdg.dataHome}/python-eggs";
        PYTHONHISTFILE = "${config.xdg.dataHome}/python/python_history"; # default value as of >=3.4

        # Tools
        # IPYTHONDIR = "$XDG_CONFIG_HOME/ipython";
        # JUPYTER_CONFIG_DIR = "$XDG_CONFIG_HOME/jupyter";
        # PIP_CONFIG_FILE = "${configHome}/pip/pip.conf";
        # PIP_LOG_FILE = "${stateHome}/pip/log";
        # PYLINTHOME = "$XDG_DATA_HOME/pylint";
        # PYLINTRC = "$XDG_CONFIG_HOME/pylint/pylintrc";
        # WORKON_HOME = "$XDG_DATA_HOME/virtualenvs";
      };
    })
  ];
}
