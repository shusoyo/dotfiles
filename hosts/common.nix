{ pkgs, ... }: {

  imports = [
    ../modules
  ];

  ## Home Manager
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  nix = {
    package = pkgs.nix;

    ## It's doesn't matter to set the following options,
    ## because the home-manager can't be used to manage the system configuration.
    # settings.trusted-users = ["root" config.home.username];
    settings.use-xdg-base-directories = true;
    settings.auto-optimise-store = true;
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
