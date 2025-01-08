{ inputs, config, lib, pkgs, ... }: {

  imports = [
    ../general/system.nix
    inputs.wsl.nixosModules.default
    # ./hardware-configuration.nix
    # ./network.nix
  ];

  wsl.enable = true;

  # boot.loader.systemd-boot.enable = true;
  # boot.loader.efi.canTouchEfiVariables = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.printer = {
    home         = "/home/printer";
    shell        = pkgs.fish;
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/"
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ10Z63y5BH9a2rrW2tDVKBZkAYc84SLMOBcE7EsWFHG"
    ];
  };

  documentation.man.generateCaches = lib.mkForce false;

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
