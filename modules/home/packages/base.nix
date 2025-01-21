{ lib, pkgs, config, ss, ... }:

let
  cfg = config.modules.packages;
in {
  options.modules.packages = {
    use-base-packages = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.use-base-packages {
    home.packages = with pkgs; [
      #                      -
      # Shells
      dash

      # Encrypt
      sops                   age

      # Tools
      fzf                    ripgrep
      tree                   less
      htop                   unzip

      wget                   curl
      simple-http-server

      # System info
      neofetch

      # Nix warpper
      nh
      #                      -
    ];
  };
}
