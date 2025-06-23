{ ss, lib, config, ... }:

let
  cfg = config.modules.packages.homebrew;

  homebrew-proxy = config.lib.shell.exportAll {
    HOMEBREW_API_DOMAIN      = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN   = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL   = "https://mirrors.tuna.tsinghua.edu.cn/pypi/web/simple";
  };
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
        ${homebrew-proxy}
        /usr/local/bin/brew bundle install \
          --file=${config.xdg.configHome}/Brewfile \
          --upgrade \
          --cleanup --force
          # --no-upgrade
          # --no-lock
      '';
    };

    home.shellAliases = {
      brew = ''${homebrew-proxy}
      /usr/local/bin/brew'';
    };
  };
}
