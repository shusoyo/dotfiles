{ lib }:

let
  inherit (lib) filterAttrs genAttrs hasSuffix attrValues mapAttrs;

  # 从 inputs 中提取适配当前平台的模块集（单一 target，无多余 fallback）
  platformModulesOf = system: inputs:
    let
      target = if hasSuffix "-darwin" system then "darwinModules" else "nixosModules";
    in
      mapAttrs (_: input: input.${target} or {}) inputs;

  # 统一的系统构建器
  buildSystem = { inputs, self, extendedLib, overlayList }:
    hostName: { system, path, ... }:
    let
      builder =
        if hasSuffix "-darwin" system
        then inputs.darwin.lib.darwinSystem
        else inputs.nixpkgs.lib.nixosSystem;
    in
    builder {
      modules = [
        {
          nixpkgs.hostPlatform = system;
          nixpkgs.overlays = overlayList;
        }
        ../modules
        path
      ];
      specialArgs = {
        inherit inputs self;
        lib = extendedLib;
        ss = {
          modules = platformModulesOf system inputs;
          packages = self.packages.${system} or {};
          configDir = self + /config;
        } // (import ./options.nix { inherit lib; });
      };
    };
in
{
  mkFlake = inputs@{ self, nixpkgs, ... }:
    { systems ? [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ]
    , hosts ? {}
    , overlays ? {}
    , packages ? {}
    , ...
    }@extra:
    let
      overlayList = attrValues overlays;
      pkgsFor = system: import nixpkgs { inherit system; overlays = overlayList; config.allowUnfree = true; };
      extendedLib = nixpkgs.lib.extend (self: super: import ./. { lib = self; });

      systemArgs = {
        inherit inputs self extendedLib overlayList;
      };
    in
    (removeAttrs extra [ "systems" "hosts" "overlays" "packages" ]) // {
      inherit overlays;
      lib = extendedLib;

      darwinConfigurations = mapAttrs
        (buildSystem systemArgs)
        (filterAttrs (_: h: hasSuffix "-darwin" h.system) hosts);

      nixosConfigurations = mapAttrs
        (buildSystem systemArgs)
        (filterAttrs (_: h: hasSuffix "-linux" h.system) hosts);

      packages = genAttrs systems (system:
        let pkgs = pkgsFor system; in
        mapAttrs (_: pkgPath: pkgs.callPackage pkgPath {}) packages
      );

      formatter = genAttrs systems (system:
        (pkgsFor system).nixfmt-rfc-style
      );
    };
}
