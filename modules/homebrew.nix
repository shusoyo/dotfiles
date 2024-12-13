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
