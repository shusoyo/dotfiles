{ config, pkgs, lib, ... }: with lib; 
let
  taps = [
    "homebrew/bundle"
    "homebrew/services"
    # "koekeishiya/formulae"
  ];

  brews = [
  ];

  casks = [
    "appcleaner"
    "font-fira-code"
    "font-fira-code-nerd-font"
    "font-noto-sans-cjk"
    "font-noto-serif-cjk"
    "arc"
    # "docker"
    "kitty"
    # "mos"
    # "raycast"
    # "utm"
    # "visual-studio-code"
    # "zed"
    # "clash-verge-rev"
    # "sfm"
    # "syncthing"
  ];
in
{
  # home.sessionPath = [ "/opt/homebrew/bin" ];

  home.file.".Brewfile" = {
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
      /usr/local/bin/brew bundle install --cleanup --no-upgrade --force --no-lock --global
    '';
  };
}
