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

    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs@{ self, nixpkgs, home-manager, darwin, ... }: let
    gen = import ./lib/generator.nix inputs;

    ss-home      = gen.home-conf-gen  "ss"    "suspen"  "x86_64-darwin";
    ss-system    = gen.macos-conf-gen "ss"    "suspen"  "x86_64-darwin";

    camel        = gen.nixos-conf-gen "camel" "mirage"  "x86_64-linux";

    hwcloud      = gen.nixos-conf-gen "hwc"   "root"    "x86_64-linux";
    sis          = gen.nixos-conf-gen "sis"   "typer"   "x86_64-linux";
  in gen.merge-conf [
    ss-system
    ss-home

    camel

    hwcloud
    sis
  ];
}
