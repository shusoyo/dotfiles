{ pkgs, ... }: {

  imports = [
    ../modules
  ];

  ## Home Manager
  programs.home-manager.enable = true;
  home.stateVersion = "24.11";

  modules = {
    ssh.enable = true;
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
