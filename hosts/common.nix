{ pkgs, ... }: {

  imports = [
    ../modules
  ];

  ## Home Manager
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  nix = {
    package = pkgs.nix;
    settings.auto-optimise-store      = true;
    settings.use-xdg-base-directories = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
      warn-dirty = false
    '';
  };

  modules = {
    xdg.enable = true;

    dev = {
      rust.enable   = true;
      python.enable = true;
    };

    shell = {
      git.enable  = true;
      nvim.enable = true;
      yazi.enable = true;
      fish.enable = true;

      # base utils
      baseUtils.enable = true;
    };
  };
}
