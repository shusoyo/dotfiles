{ ss, lib, config, pkgs, ... }:

let
  cfg = config.modules.nix-nixpkgs-settings;
in {
  options.modules.nix-nixpkgs-settings = {
    enable = ss.mkBoolOpt false;
  };

  config = lib.mkIf cfg.enable {
    nix.package = pkgs.nix;

    nix.gc = {
      automatic = true;
      options   = "--delete-older-than 7d";
    };

    nix.optimise.automatic = true;

    nix.settings = {
      warn-dirty               = false;
      use-xdg-base-directories = true;
      trusted-users            = [ ss.username "root" ];
      experimental-features    = ["nix-command" "flakes"];

      builders-use-substitutes = true;
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store"
      ];
    };

    nixpkgs.config.allowUnfree = true;
  };
}

