{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  boot.initrd.availableKernelModules = [ "xhci_pci" "ahci" "nvme" "usbhid" "usb_storage" "sd_mod" ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-intel" ];
  boot.extraModulePackages = [ ];

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;

  disko.devices.disk = {
    main = {
      type   = "disk";
      device = "/dev/nvme0n1";

      content = {
        type = "gpt";

        partitions = {
          ESP = {
            priority = 1;
            name     = "ESP";
            start    = "1M";
            end      = "512M";
            type     = "EF00";

            content = {
              type         = "filesystem";
              format       = "vfat";
              mountpoint   = "/boot";
              mountOptions = [ "umask=0077" ];
            };
          };
          root = {
            size = "100%";

            content = {
              type      = "btrfs";
              extraArgs = [ "-f" ];

              subvolumes = {
                "/root" = {
                  mountpoint   = "/";
                  mountOptions = [ "compress=zstd" ];
                };
                "/home" = {
                  mountpoint   = "/home";
                  mountOptions = [ "compress=zstd" ];
                };
                "/nix" = {
                  mountpoint   = "/nix";
                  mountOptions = [ "compress=zstd" "noatime" ];
                };
              };
            };
          };
        };
      };
    };
  };
}
