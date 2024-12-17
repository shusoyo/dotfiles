{ pkgs, config, ... }: {

  imports = [
    ../modules
  ];

  ## Home Manager
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  ## packages
  home.packages = with pkgs; [
    # luajitPackages.luarocks-nix (dependency of neorg)
    luajit
  ];

  nix = {
    package = pkgs.nix;
    settings.trusted-users = ["root" config.home.username];
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
      rust.enable = true;
    };

    shell = {
      git.enable    = true;
      nvim.enable   = true;
      yazi.enable   = true;
      elvish.enable = true;

      # base utils
      baseutils.enable = true;
    };
  };
}
