{ config, pkgs, ... }: {

  services.syncthing = {
    enable = true;
    openDefaultPorts = true;
    settings.gui = {
      user = "myuser";
      password = "mypassword";
    };
  };
}
