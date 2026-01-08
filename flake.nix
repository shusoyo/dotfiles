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

    typer = gen.macos-conf-gen "typer" "suspen" "aarch64-darwin";
    ss    = gen.macos-conf-gen "ss"    "suspen" "x86_64-darwin";
  in gen.merge-conf [
    # pc
    typer
    ss
  ];
}
