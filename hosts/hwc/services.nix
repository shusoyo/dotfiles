{ config, pkgs, ... }: {

  sops.secrets."github-runner-token" = {};

  services.github-runners.hwc = {
    enable = true;
    name = "hwc";
    tokenFile = "${config.sops.secrets.github-runner-token.path}";
    url = "https://github.com/shusoyo/halfyear";
    extraLabels = [ "nixos" ];
    extraPackages = [
      pkgs.typst
      pkgs.gitMinimal
    ];
  };
}
