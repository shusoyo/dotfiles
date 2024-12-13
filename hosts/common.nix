{ pkgs, config, ... }: with builtins; {

  imports = [
    ../modules/cli.nix
    ../modules/dev
    ../modules/shell
  ];

  ## Home Manager
  programs.home-manager.enable = true;
  home.stateVersion = "24.05";

  ## packages
  home.packages = with pkgs; [
    #                      -                      -                      -
    fzf                    ripgrep                hugo                   htop 
    elvish                 zsh                    dash
    wget                   curl                   unzip
    neofetch               tree
    luajit                 # luajitPackages.luarocks-nix (dependency of neorg)
  ] ++ (if pkgs.stdenv.isDarwin then [
    coreutils

    ## nix language server for zed editor
    nixd

    typst    tinymist
  ] else [
    zip
  ]);

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

  modules = {
    dev = {
      xdg.enable  = true;
      rust.enable = true;
    };

    shell = {
      git.enable = true;
    };
  };
}
