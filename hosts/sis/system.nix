{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ../general/system.nix
    ./services.nix
  ];

  # Modules options first
  # ------------------------------------------------------
  modules.sops = {
    enable   = true;
    sopsFile = ./asserts/secrets.yaml;
  };

  modules.home-manager.enable = true;
  home-manager = {
    users.typer = import ./home.nix;
  };

  # Networking
  # ------------------------------------------------------
  networking = {
    hostName    = "sis";
    useDHCP     = false;
    useNetworkd = true;

    firewall.enable = false;
  };

  systemd.network.enable = true;
  systemd.network.networks."50-usb-RNDIS" = {
    matchConfig.Name = "enp0s20f0*";
    DHCP = "yes";
    dhcpV4Config = {
      RouteMetric = 100;
    };
  };

  # users
  # ------------------------------------------------------
  users.users = let
    ssh-keys = with ss.ssh-id; [ ss0 ss1 ms0 ];
  in {
    typer = {
      home         = "/home/typer";
      shell        = pkgs.fish;
      isNormalUser = true;
      extraGroups  = [ "wheel" ];

      openssh.authorizedKeys.keys = ssh-keys;
    };

    root = {
      openssh.authorizedKeys.keys = ssh-keys;
    };
  };

  environment.systemPackages = [
    pkgs.curl
    pkgs.vim
    pkgs.wget
    pkgs.gitMinimal
    pkgs.mtr
  ];

  # Low level
  # ------------------------------------------------------
  boot = {
    loader = {
      systemd-boot.enable      = true;
      efi.canTouchEfiVariables = true;
    };

    kernelModules = [ "kvm-intel" ];
    initrd.availableKernelModules = [
      "xhci_pci"
      "ahci"
      "nvme"
      "usbhid"
      "usb_storage"
      "sd_mod"
    ];

    kernel.sysctl = {
      "net.ipv4.ip_forward" = 1;
    };
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  fileSystems."/media/hdd" = {
    device = "/dev/disk/by-uuid/02a16087-9023-4666-b42b-075ba0dc3cfa";
    fsType = "btrfs";
    options = [ "subvol=@data-only" "compress=zstd" "noatime"];
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/4a9450b4-791f-4793-ab04-7b4e4000c726";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/4a9450b4-791f-4793-ab04-7b4e4000c726";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/4a9450b4-791f-4793-ab04-7b4e4000c726";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/D978-FC83";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };

  swapDevices = [ { device = "/swap/swapfile"; } ];

  system.stateVersion = "25.05";
}
