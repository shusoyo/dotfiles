{ inputs, pkgs, ss, ... }: {

  imports = [
    ../common.nix
    ./homebrew.nix
    inputs.agenix.homeManagerModules.default
  ];

  home.username = ss.username;
  home.homeDirectory = ss.homeDirectory;

  home.packages = with pkgs; [
    # GNU coreutils is used to replaced with apple xcode-develop-tools
    coreutils

    # nix language server for zed editor.
    nixd                      nil

    inputs.agenix.packages.${ss.system}.default
  ];

  modules.agenix.enable = true;
  age.secrets."ssh_hosts" = {
    file = ./secrets/ssh_hosts.age;
    path = "${ss.homeDirectory}/.ssh/config.d/ssh_hosts";
  };

  modules = {
    app = {
      kitty.enable = true;
      zed.enable   = true;
    };

    dev = {
      node.enable  = true;
      typst.enable = true;
    };
  };
}
