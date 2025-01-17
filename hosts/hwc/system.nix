{ modulesPath, inputs, config, lib, pkgs, ss, ... }: {

  imports = [
    (modulesPath + "/profiles/qemu-guest.nix")
    ../general/system.nix
    ./disk.nix
    ./services.nix

    inputs.disko.nixosModules.disko
  ];

  boot.initrd.availableKernelModules = [ "ata_piix" "uhci_hcd" "virtio_pci" "virtio_scsi" "virtio_blk" ];

  networking.useDHCP = lib.mkDefault true;
  networking.hostName = "hwc";

  nixpkgs.hostPlatform = lib.mkDefault "x86_64-linux";

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

  boot.loader.grub = {
    efiSupport = true;
    efiInstallAsRemovable = true;
  };

  time.timeZone = "Asia/Shanghai";

  i18n.defaultLocale = "en_US.UTF-8";

  users.users.root = {
    shell = pkgs.fish;

    openssh.authorizedKeys.keys = [
      ss.ssh-id.ss0
      ss.ssh-id.ss1
    ];
  };

  system.stateVersion = "25.05";
}
