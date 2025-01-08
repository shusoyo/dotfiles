{ config, pkgs, ... }: {

  sops.secrets."github-runner-token" = {};

  services.github-runners.hwc = {
    enable    = true;
    name      = "hwc";
    url       = "https://github.com/shusoyo/halfyear";
    tokenFile = "${config.sops.secrets.github-runner-token.path}";

    extraLabels   = [ "nixos" ];
    extraPackages = [
      pkgs.gitMinimal
    ];
  };
}
