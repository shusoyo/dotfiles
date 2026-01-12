{ pkgs, ss, ... }: {

  imports = [
    ../../modules/home
  ];

  programs.home-manager.enable = true;

  home = {
    stateVersion  = "25.11";
    homeDirectory = ss.home-path;
    username      = ss.username;
  };

  modules = {
    packages.use-base-packages = true;

    xdg.enable = true;

    shell = {
      git.enable  = true;
      nvim.enable = true;
      yazi.enable = true;
      fish.enable = true;
    };
  };
}
