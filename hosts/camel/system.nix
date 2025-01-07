{ inputs, config, lib, pkgs, ... }: {

  imports = [
    ../general/system.nix
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

  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
    pkgs.typst
  ];

  fonts.packages = let
    typst-noto-cjk-sc = pkgs.noto-fonts-cjk-serif.overrideAttrs (rec {
      version = "2.003";

      src = pkgs.fetchFromGitHub {
        owner = "notofonts";
        repo = "noto-cjk";
        rev = "Serif${version}";
        hash = "sha256-mfbBSdJrUCZiUUmsmndtEW6H3z6KfBn+dEftBySf2j4=";
        sparseCheckout = [ "Serif/OTC" ];
      };

      installPhase = ''
        install -m444 -Dt $out/share/fonts/typst-test-fonts Serif/OTC/*.ttc
      '';
    });
  in [
    typst-noto-cjk-sc
  ];

  services.openssh.enable = true;

  system.stateVersion = "25.05";
}
