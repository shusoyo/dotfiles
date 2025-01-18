{ config, pkgs, ... }: {

  sops.secrets."gh-pat" = {};

  services.github-runners.halfyear = {
    enable    = true;
    name      = "halfyear-runner";
    url       = "https://github.com/shusoyo/halfyear";
    tokenFile = "${config.sops.secrets.gh-pat.path}";

    extraLabels   = [ "nixos" ];
    extraPackages = [ pkgs.gitMinimal ];
  };
}
