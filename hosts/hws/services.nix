{ config, pkgs, ... }: {

  sops.secrets.gh-runner-token = {};

  services.github-runners.halfyear = {
    enable    = true;
    name      = "halfyear-runner";
    url       = "https://github.com/shusoyo/halfyear";
    tokenFile = "${config.sops.secrets.gh-runner-token.path}";

    extraLabels   = [ "nixos" ];
    extraPackages = [ pkgs.gitMinimal ];
  };
}
