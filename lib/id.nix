{ self, username, system, hostname, ... }:

rec {
  inherit username system hostname;

  ssh-id = {
    ss0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIISZsL01ZNWdI41391bZayqRlq5cbWYlEZ0mXmpnlbf+";
    ss1 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ10Z63y5BH9a2rrW2tDVKBZkAYc84SLMOBcE7EsWFHG";
    ms0 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIL/8ffDIjg1JkYfZO79Co49T44nugh1MnjOl63Z8/R92";
    ssx = "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQCpRql9fEy329e7hbOA6SjQbwP9L5+6c52YQNQuknbOsH+kpdAyiClaleOInZqn3+oX9qQhaM8SRbxXO24kzuQ/FSxJLBoUh/4qtT9If++Xxcm+EUGg2J0Dan7jPjeZoOi4+1QnzvEBfj3n6zgBDtKgzOK38z4gIrMYqyljjLCPA0vSXKZBErCN68tAqRfJ5OxYKSPXMkm0XWRlmRwMNit5U4hzsf6hPqu+AjH9yqo/5vbw8FMAcci2CccW2gOePp2GEmteMiBaH049jbcDc5IYRIZTYYyxKh/Fh/snTIGmL3hfHDuVWuqALkigYEH0r3vM6IWcnZCxQYjRdZzzonGqmdU5k1TshJeBv5+4pt1XacuTPlIlgDDcmWpxr2nIIr9okvbRqe153radhILNJFHKqpQrKbq3pIy25wGKbBwmsfdKYYkDSXFGwcH7nTSC3fc7YELdEraaHkNxrMUb4EQ0t63T9q7N2K8D2Qny5ElNh/G20ytYVO1JosJUNy2lx9s=";
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
