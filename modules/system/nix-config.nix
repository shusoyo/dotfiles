{ lib, config, ... }:

let
  cfg = config.modules.nix-settings;
in {
  options.modules.nix-settings = {
    enable = ss.mkBoolOpt false;
  };

  config = mkIf cfg.enable {
    nix.gc = {
      automatic = true;
      options   = "--delete-older-than 7d";
    };

    nix.settings = {
      warn-dirty               = false;
      auto-optimise-store      = true;
      use-xdg-base-directories = true;
      trusted-users            = ["mirage" "root"];
      experimental-features    = ["nix-command" "flakes"];

      builders-use-substitutes = true;
      substituters = [
        "https://mirrors.cernet.edu.cn/nix-channels/store"
      ];
    };

    nixpkgs.config.allowUnfree = true;
  };
}

