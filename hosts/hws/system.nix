{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.disko.nixosModules.disko

    ../general/system.nix
    ./services.nix
  ];

  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
  };

  modules.no-doc.enable = true;

  environment.systemPackages = [
    pkgs.gitMinimal
  ];

  users.users.root = {
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      ss.ssh-id.ss0
      ss.ssh-id.ss1
    ];
  };

  networking.useDHCP  = true;
  networking.hostName = "hws";

  nixpkgs.hostPlatform = "x86_64-linux";

  system.stateVersion = "25.05";

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
    };
  };

  disko.devices.disk.main = {
    type   = "disk";
    device = "/dev/vda";

    content = {
      type = "gpt";

      partitions.boot = {
        name = "boot";
        size = "1M";
        type = "EF02";
      };

      partitions.ESP = {
        priority = 1;
        name     = "ESP";
        end      = "500M";
        type     = "EF00";

        content = {
          type         = "filesystem";
          format       = "vfat";
          mountpoint   = "/boot";
          mountOptions = [ "umask=0077" ];
        };
      };

      partitions.root = {
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
}
