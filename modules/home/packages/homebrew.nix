{ ss, lib, config, ... }:

let
  cfg = config.modules.packages.homebrew;

  homebrew-env = {
    HOMEBREW_API_DOMAIN      = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN   = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL   = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
  };

  export-homebrew-env = config.lib.shell.exportAll homebrew-env;

  brew-path =
    if ss.system == "x86_64-darwin" then
      "/usr/local/bin/brew"
    else
      "/opt/homebrew/bin/brew"
  ;
in {
  options.modules.packages.homebrew = with lib.types; {
    enable = ss.mkBoolOpt false;
    taps   = ss.mkOpt (listOf str) [];
    casks  = ss.mkOpt (listOf str) [];
    brews  = ss.mkOpt (listOf str) [];
  };

  config = lib.mkIf cfg.enable {
    xdg.configFile."Brewfile" = with lib; {
      text =
        (concatMapStrings (tap: "tap \"${tap}\"\n") cfg.taps)
          +
        (concatMapStrings (brew: "brew \"${brew}\"\n") cfg.brews)
          +
        (concatMapStrings (cask: "cask \"${cask}\"\n") cfg.casks);
      onChange = ''
        eval "$(${brew-path} shellenv)"
        ${export-homebrew-env}
        ${brew-path} bundle install \
          --file=${config.xdg.configHome}/Brewfile \
          --upgrade \
          --cleanup --force \
          -v
          # --no-upgrade
          # --no-lock
      '';
    };

    # home.sessionVariables = homebrew-env;

    # home.shellAliases = {
    #   # brew = ''${homebrew-env}
    #   # /opt/homebrew/bin/brew'';
    # };
  };
}
