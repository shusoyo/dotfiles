{ pkgs, config, ... }: {

  imports = [
    ../modules/cli.nix
    ../modules/dev
  ];

  ## Home Manager
  programs.home-manager.enable = true;

  ## packages
  home.packages = with pkgs; [
    #                      -                      -                      -
    fzf                    ripgrep                hugo                   htop 
    elvish                 zsh                    dash
    wget                   curl                   unzip
    neofetch               sheldon                tree
    luajit                 # luajitPackages.luarocks-nix (dependency of neorg)
  ] ++ (if pkgs.stdenv.isDarwin then [
    coreutils
    ## nix language server for zed editor
    nixd
  ] else []);

  xdg.enable = true;

  nix = {
    package = pkgs.nix;
    settings.trusted-users = ["root" config.home.username];
    settings.use-xdg-base-directories = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
      warn-dirty = false
    '';
  };

  modules.dev = {
    xdg.enable  = true;

    rust.enable = true;
  };
}
