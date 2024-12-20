{ ss, ... }: with ss; {

  imports = [
    ../common.nix
  ];

  home.username = username;
  home.homeDirectory = homeDirectory;
}
