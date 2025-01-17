{ config, lib, pkgs, modulesPath, ... }: {

  boot.initrd.availableKernelModules = [ "virtio_pci" "xhci_pci" "usbhid" "usb_storage" "sd_mod" "virtio_blk" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ ];
  boot.extraModulePackages = [ ];

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

  swapDevices = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
}
