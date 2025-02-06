{ inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    ../prelude/local.nix
  ];

  # Modules
  # ------------------------------------------------------
  modules.home-manager.enable = true;
  home-manager = {
    users.mirage = import ./home.nix;
  };

  # modules.sops = {
  #   enable = true;
  # };
 
  # Users
  # ------------------------------------------------------
  users.users.mirage = {
    home         = "/home/mirage";
    shell        = pkgs.fish;
    isNormalUser = true;
    extraGroups  = [ "wheel" ];

    openssh.authorizedKeys.keys = [ ss.ssh-id.ss0 ];
  };

  environment.systemPackages = [
    pkgs.vim
    pkgs.wget
  ];

  # Networking
  # ------------------------------------------------------
  networking = {
    useNetworkd = true;
    useDHCP     = false;

    firewall = {
      enable = false;
    };
  };

  systemd.network = {
    enable = true;

    networks."enp0s1" = {
      matchConfig.Name = "enp0s1";
      address = [
        "192.168.64.2/24"
      ];
      routes  = [
        { Gateway = "192.168.64.1"; }
      ];
    };
  };

  services.avahi = {
    enable       = true;
    nssmdns4     = true;
    openFirewall = true;

    publish = {
      enable       = true;
      userServices = true;
    };
  };

  # System
  # ------------------------------------------------------
  boot = {
    kernelPackages = pkgs.linuxPackages_6_6;

    initrd.availableKernelModules = [
      "virtio_pci"
      "xhci_pci"
      "usbhid"
      "usb_storage"
      "sd_mod"
      "virtio_blk"
    ];

    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
      timeout = 1;
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/ff3002c8-e065-480d-ae77-c23c7d61a308";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/ff3002c8-e065-480d-ae77-c23c7d61a308";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/ff3002c8-e065-480d-ae77-c23c7d61a308";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/E927-0120";
    fsType = "vfat";
    options = [ "fmask=0022" "dmask=0022" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];
}
