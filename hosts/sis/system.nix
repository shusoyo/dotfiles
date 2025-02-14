{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")

    ../prelude/local.nix
    ./services.nix
  ];

  # Modules options
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
    useDHCP     = false;
    useNetworkd = true;

    firewall.enable = false; # No local firewall
  };

  services.resolved = {
    enable  = true;
    domains = [ "~." ];
    fallbackDns = [ "223.5.5.5" "8.8.8.8" ];
    dnsovertls  = "opportunistic";
    extraConfig = ''
      DNSStubListenerExtra=10.0.0.1
      MulticastDNS=no
    '';
  };

  systemd.network = {
    enable = true;

    networks."50-usb-RNDIS" = {
      matchConfig.Name = "enp0s20f0*";
      DHCP = "yes";
      dhcpV4Config = {
        RouteMetric = 128;
      };
    };

    networks."10-enp1s0" = {
      matchConfig.Name = "enp1s0";

      address = [ "10.85.13.10/25" ];

      # routes  = [
      #   { Gateway = "10.85.13.1"; Metric = 300; }
      # ];

      networkConfig = {
        DHCPServer = "yes";
      };

      dhcpServerConfig = {
        ServerAddress = "10.0.0.1/24";
        PoolOffset = 20;
        PoolSize   = 100;
        DNS = [ "10.0.0.1" ];
      };

      dhcpServerStaticLeases = [
        # ap
        { MACAddress = "5c:02:14:9e:d6:dd"; Address = "10.0.0.2";  }
        # ss
        { MACAddress = "00:e2:69:6e:2c:ed"; Address = "10.0.0.10"; }
      ];
    };
  };

  networking.nftables = {
    enable = true;
    rulesetFile = ./asserts/ruleset.nft;
  };

  # PPPOE
  sops.secrets.pppoe-name = {};
  sops.secrets.pppoe-password = {};

  sops.templates.edpnet.content = ''
    plugin pppoe.so enp1s0

    name "${config.sops.placeholder.pppoe-name}"
    password "${config.sops.placeholder.pppoe-password}"

    persist
    usepeerdns
    defaultroute
    defaultroute-metric 256
  '';

  services.pppd = {
    enable = true;
    peers.edpnet = {
      enable    = true;
      autostart = true;
      config    = "file ${config.sops.templates.edpnet.path}";
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
      extraGroups  = [ "wheel" "incus-admin" ];

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
      "net.ipv4.ip_forward" = true;
      "net.ipv4.conf.all.forwarding" = true;
      "net.ipv6.conf.all.forwarding" = false;
    };
  };

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
}
