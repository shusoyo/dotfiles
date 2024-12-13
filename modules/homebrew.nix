{ config, pkgs, lib, ... }: with lib; 
let
  taps = [
    "homebrew/bundle"
    "homebrew/services"
  ];

  brews = [
    "bitwarden-cli"
  ];

  casks = [
    "appcleaner"

    # Fonts
    "font-fira-code"
    "font-fira-code-nerd-font"
    "font-noto-sans-cjk"
    "font-noto-serif-cjk"

    # Web Browser
    "arc"

    # "docker"
    "kitty"
    "mos"
    "raycast"
    # "utm"
    "visual-studio-code"
    "clash-verge-rev"
    "sfm"
    "syncthing"
  ];
in
{
  # home.sessionPath = [ "/opt/homebrew/bin" ];

  home.sessionVariables = {
    HOMEBREW_API_DOMAIN      = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles/api";
    HOMEBREW_BOTTLE_DOMAIN   = "https://mirrors.tuna.tsinghua.edu.cn/homebrew-bottles";
    HOMEBREW_BREW_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/brew.git";
    HOMEBREW_CORE_GIT_REMOTE = "https://mirrors.tuna.tsinghua.edu.cn/git/homebrew/homebrew-core.git";
    HOMEBREW_PIP_INDEX_URL   = "https://pypi.tuna.tsinghua.edu.cn/simple";
  };

  xdg.configFile."Brewfile" = {
    text =
      (concatMapStrings (
        tap:
        ''tap "''
        + tap
        + ''
          "
        ''

      ) taps)
      + (concatMapStrings (
        brew:
        ''brew "''
        + brew
        + ''
          "
        ''

      ) brews)
      + (concatMapStrings (
        cask:
        ''cask "''
        + cask
        + ''
          "
        ''

      ) casks);
    onChange = ''
      /usr/local/bin/brew bundle install --file=${config.xdg.configHome}/Brewfile --cleanup --no-upgrade --force --no-lock
    '';
  };
}