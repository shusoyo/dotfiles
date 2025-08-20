{ inputs, config, ... }: {

  imports = [
    ../prelude/home.nix
  ];

  modules = {
    shell = {
      fish.shellProxy = "7890";
    };
  };

  modules.sops = {
    enable = true;
    sopsFile = ./asserts/secrets.yaml;
  };

  sops.secrets.syncthing-gui-password = {};

  services.syncthing = {
    enable = true;
    passwordFile = "${config.sops.secrets.syncthing-gui-password.path}";
    guiAddress = "0.0.0.0:8384";
    settings = {
      options = {
        globalAnnounceEnabled = false;
        relaysEnabled = false;
      };
      gui = {
        user = "suspen";
      };
      devices = {
        "ss_iphone" = { id = "6D52CQG-JXIWTKB-QFDIRSH-7TFSQVS-OXWBMLW-R5MPXPO-24WGH2Y-LRBNPQT"; };
        "ss_mac"    = { id = "LZM4CG6-CTNNPDS-CH45TIB-GMFD7QB-XW6CHLH-O3GP3Q5-7O4F6IB-DHA44AO"; };
        "ss_ipad"   = { id = "PJUAYSZ-GZ2VOZR-SMB2ZJL-AYRGQAI-FYXXDGI-TXBAYUI-B4ZVC6Q-RFBDHQI"; };
      };
      folders = {
        "sync" = {
          path = "/home/typer/syncthing/sync";
          devices = [ "ss_iphone" "ss_mac" "ss_ipad" ];
        };
        "backup" = {
          path = "/home/typer/syncthing/backup/";
          devices = [ "ss_mac" ];
        };
      };
    };
  };


}
