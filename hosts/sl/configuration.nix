{ inputs, config, lib, pkgs, ... }: {

  imports = [
    ./hardware-configuration.nix
  ];

  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.sl = {
    home = "/home/sl";
    isNormalUser = true;
    extraGroups = [ "wheel" ];

    packages = with pkgs; [
      tree
    ];

    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/"
    ];
  };

  # programs.firefox.enable = true;

  environment.shells = [ pkgs.fish ];
  programs.fish = {
    enable       = true;
    useBabelfish = true;

    shellInit = ''
    '';
  };

  environment.systemPackages = with pkgs; [
    vim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
  ];


  services.openssh.enable = true;

  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  system.stateVersion = "24.11";

  nix.gc = {
    automatic = true;
    options   = "--delete-older-than 7d";
  };

  nix.settings = {
    warn-dirty               = false;
    use-xdg-base-directories = true;
    trusted-users            = [ "sl" ];
    experimental-features    = ["nix-command" "flakes"];

    builders-use-substitutes = true;
    substituters = [
      "https://mirrors.cernet.edu.cn/nix-channels/store"
    ];
  };

  nixpkgs.config.allowUnfree = true;
}
