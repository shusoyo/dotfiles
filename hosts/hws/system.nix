{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")

    ../prelude/server.nix
    ./services.nix
  ];

  modules.sops = {
    enable   = true;
    sopsFile = ./asserts/secrets.yaml;
  };

  environment.systemPackages = [
    pkgs.gitMinimal
  ];

  time.timeZone = "Asia/Singapore";

  users.users.root = {
    openssh.authorizedKeys.keys = [
      ss.ssh-id.ss0
      ss.ssh-id.ss1
    ];
  };

  networking.useDHCP  = true;

  boot = {
    initrd.kernelModules = [ "dm-snapshot" ];
    initrd.availableKernelModules = [
      "ata_piix"
      "uhci_hcd"
      "virtio_pci"
      "virtio_scsi"
      "virtio_blk"
    ];

    loader.grub = {
      efiSupport = true;
      efiInstallAsRemovable = true;
      devices = [ "/dev/vda" ];
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/29640140-75f8-4c62-b377-e3db405d306e";
    fsType = "btrfs";
    options = [ "subvol=root" "compress=zstd" "noatime"];
  };

  fileSystems."/nix" = {
    device = "/dev/disk/by-uuid/29640140-75f8-4c62-b377-e3db405d306e";
    fsType = "btrfs";
    options = [ "subvol=nix" "compress=zstd" "noatime"];
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/29640140-75f8-4c62-b377-e3db405d306e";
    fsType = "btrfs";
    options = [ "subvol=home" "compress=zstd" "noatime"];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/FD7B-869A";
    fsType = "vfat";
    options = [ "fmask=0077" "dmask=0077" ];
  };
}
