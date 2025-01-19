{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../general/system.nix
    ./services.nix
  ];

  networking.useDHCP  = true;
  networking.hostName = "cts";

  nixpkgs.hostPlatform = "x86_64-linux";

  modules.sops = {
    enable   = true;
    sopsFile = ./secrets/secrets.yaml;
  };

  environment.systemPackages = [
    pkgs.curl
    pkgs.vim
    pkgs.wget
    pkgs.gitMinimal
  ];

  users.users.root = {
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      ss.ssh-id.ss0
      ss.ssh-id.ss1
    ];
  };

  boot = {
    kernelParams = [
      "console=ttyS0,115200n8"
      "console=tty0"
    ];

    initrd.availableKernelModules = [
      "uhci_hcd"
      "ehci_pci"
      "xhci_pci"
      "sr_mod"
      "virtio_blk"
      "ahci"
      "ata_piix"
      "virtio_pci"
      "xen_blkfront"
      "vmw_pvscsi"
    ];

    loader.grub = {
      enable = true;
      device = "/dev/vda";
    };
  };

  fileSystems."/" = {
    device = "/dev/disk/by-uuid/b7b2ae55-7f78-4c91-9e0a-c73957b70484";
    fsType = "ext4";
  };

  system.stateVersion = "25.05";
}
