{
  description = "Configuration of suspen";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    darwin = {
      url = "github:lnl7/nix-darwin";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    sops-nix = {
      url = "github:Mic92/sops-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }: let
    gen = import ./lib/generator.nix inputs;

    ss-home   = gen.home-conf-gen  "ss"    "suspen" "x86_64-darwin";
    ss-system = gen.macos-conf-gen "ss"    "suspen" "x86_64-darwin";
    camel     = gen.nixos-conf-gen "camel" "mirage" "x86_64-linux";
    hws       = gen.nixos-conf-gen "hws"   "root"   "x86_64-linux";
    cts       = gen.nixos-conf-gen "cts"   "root"   "x86_64-linux";
    sis       = gen.nixos-conf-gen "sis"   "typer"  "x86_64-linux";
  in gen.merge-conf [
    # pc
    ss-system    ss-home

    # local vm nixos
    camel

    # local/cloud server
    hws
    cts
    sis
  ];
}
