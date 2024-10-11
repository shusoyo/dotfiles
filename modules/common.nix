{ config, pkgs, ... }: {

  imports = [
    ./cli.nix
  ];

  ## packages 
  home.packages = with pkgs; [
    #                      -                      -                      -
    elvish                 zsh
    wget                   curl
    yazi
    neofetch
    lua
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
  ];


  programs.home-manager.enable = true;
}
