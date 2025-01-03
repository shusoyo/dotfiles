{ lib, pkgs, config, ss, ... }:

let
  cfg = config.modules.packages;
in {
  options.modules.packages = {
    use-base-packages = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.use-base-packages {
    home.packages = with pkgs; [
      #                      -                      -
      # dash is used to run .sh script,
      # elvish is a new shell language to learn
      dash                   elvish

      # encrypt
      sops                   age

      # tools
      fzf                    ripgrep
      tree                   less
      htop                   unzip

      # Network tools
      wget                   curl

      # system info
      neofetch

      # safe rm, BUT rememebr don't alias rm to gtrash
      gtrash

      # nix warpper
      nh
      #                      -                      -
    ];
  };
}
