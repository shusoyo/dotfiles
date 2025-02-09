{
  imports = [
    ./ssh.nix
    ./fish.nix
    ./sops.nix
    ./no-doc.nix
    ./headless.nix
    ./home-manager.nix
    ./nix-nixpkgs-config.nix
    ./services/simple-http-server.nix
    ./services/mdns.nix
  ];
}
