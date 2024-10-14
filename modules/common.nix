{ config, pkgs, ... }: {

  imports = [
    ./cli.nix
    ./dev.nix
  ];

  ## packages 
  home.packages = with pkgs; [
    #                      -                      -                      -
    fzf                    gitui                  hugo                   htop 
    elvish                 zsh                    dash
    wget                   curl                   ripgrep
    neofetch               sheldon                tree
    luajit                 luajitPackages.luarocks-nix
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
  ] else [ ]);

  xdg.enable = true;

  programs.home-manager.enable = true;
}
