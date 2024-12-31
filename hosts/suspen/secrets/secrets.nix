let
  suspen = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIMatQg3lxOZYs713pOojp1pWiSashfAgsVw1IgLYvPt/";
in {
  "ssh_hosts.age".publicKeys = [ suspen ];
}
