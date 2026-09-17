{
  description = "Configuration of suspen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixpkgs-unstable";

    hjem = {
      url = "github:feel-co/hjem";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:nix-darwin/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, ... }:
    let lib = import ./lib { inherit (nixpkgs) lib; }; in
      lib.mkFlake inputs {
        systems  = [ "aarch64-darwin" "x86_64-linux" ];

        hosts    = lib.mapHosts ./hosts;
        overlays = lib.mapModules ./overlays import;
        packages = lib.mapModules ./packages (p: p);
      };
}
