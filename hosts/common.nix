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
    fzf                    gitui                  hugo                   htop 
    elvish                 zsh                    dash
    wget                   curl                   ripgrep
    neofetch               sheldon                tree
    luajit                 # luajitPackages.luarocks-nix (dependency of neorg)
    unzip
    # # It is sometimes useful to fine-tune packages, for example, by applying
    # # overrides. You can do that directly here, just don't forget the
    # # parentheses. Maybe you want to install Nerd Fonts with a limited number of
    # # fonts?
    # (pkgs.nerdfonts.override { fonts = [ "FantasqueSansMono" ]; })

    # # You can also create simple shell scripts directly inside your
    # # configuration. For example, this adds a command 'my-hello' to your
    # # environment:
    # (pkgs.writeShellScriptBin "my-hello" ''
    #   echo "Hello, ${config.home.username}!"
    # '')
  ] ++ (if pkgs.stdenv.isDarwin then [
    coreutils 
    nixd ## nix language server for zed editor
  ] else []);

  xdg.enable = true;

  nix = {
    package = pkgs.nix;
    settings.trusted-users = ["root" config.home.username];
    settings.use-xdg-base-directories = true;
    extraOptions = ''
      experimental-features = nix-command flakes
      substituters = https://mirrors.tuna.tsinghua.edu.cn/nix-channels/store https://cache.nixos.org/
    '';
  };

  modules.dev = {
    xdg.enable  = true;

    rust.enable = true;
    cc.enable   = true;
  };
}
