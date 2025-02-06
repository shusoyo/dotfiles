{ self, username, system, hostname, ... }:

rec {
  inherit username system hostname;

  ssh-id = {
    ss0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISZsL01ZNWdI41391bZayqRlq5cbWYlEZ0mXmpnlbf+";
    ss1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ10Z63y5BH9a2rrW2tDVKBZkAYc84SLMOBcE7EsWFHG";
    ms0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/8ffDIjg1JkYfZO79Co49T44nugh1MnjOl63Z8/R92";
  };

  home-path = (
    if username == "root" then
      "/"
    else
      if system == "x86_64-darwin" then "/Users/" else "/home/"
  ) + username;

  abs-flake-path  = "${home-path}/.config/dotfiles";
  abs-config-path = "${abs-flake-path}/config";
  config-path     = "${self}/config";
}
