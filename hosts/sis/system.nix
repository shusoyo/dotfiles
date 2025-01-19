{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
    ../general/system.nix
    ./services.nix

    inputs.disko.nixosModules.disko
  ];

  # Modules options first
  # ------------------------------------------------------
  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
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

    # firewall = {
    #   enable = false;
    #
    #   interfaces."enp1s0" = {
    #     allowedUDPPorts = [ 67 53 ];
    #     allowedTCPPorts = [ 80 443 9090 ];
    #   };
    # };
  };

  systemd.network = {
    enable   = true;

    networks = {
      "50-usb-RNDIS" = {
        matchConfig.Name = "enp0s20f0*";
        DHCP = "yes";
        dns  = [ "8.8.8.8" ];
        dhcpV4Config = {
          RouteMetric = 100;
        };
      };

      "10-enp1s0" = {
        matchConfig.Name = "enp1s0";
        address = [
          "10.85.13.10/25"
        ];
        routes  = [
          { Gateway = "10.85.13.1"; Metric = 300; }
        ];
      };
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
  };

  nixpkgs.hostPlatform = "x86_64-linux";
  hardware.cpu.intel.updateMicrocode = true;

  disko.devices.disk.main = {
    type   = "disk";
    device = "/dev/nvme0n1";

    content = {
      type = "gpt";

      partitions.ESP = {
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

  system.stateVersion = "25.05";
}
