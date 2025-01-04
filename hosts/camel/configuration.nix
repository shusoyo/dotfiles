{ inputs, config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "camel";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.mirage = {
    home         = "/home/mirage";
    shell        = pkgs.fish;
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/"
    ];
  };

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;
  };

  environment.systemPackages = with pkgs; [
    vim
    wget
  ];

  services.openssh.enable = true;

  system.stateVersion = "24.11";

  nix.gc = {
    automatic = true;
    options   = "--delete-older-than 7d";
  };

  nix.settings = {
    auto-optimise-store      = true;
    warn-dirty               = false;
    use-xdg-base-directories = true;
    trusted-users            = [ "sl" "mirage" ];
    experimental-features    = ["nix-command" "flakes"];

    builders-use-substitutes = true;
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
