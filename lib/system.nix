{ lib }:

let
  inherit (lib) filterAttrs genAttrs hasSuffix attrValues mapAttrs;

  # 从 inputs 中提取适配当前平台的模块集，同时兼容复数 (darwinModules/nixosModules) 与单数 (darwinModule/nixosModule) 格式
  platformModulesOf = system: inputs:
    let
      isDarwin = hasSuffix "-darwin" system;
      targetPlural = if isDarwin then "darwinModules" else "nixosModules";
      targetSingular = if isDarwin then "darwinModule" else "nixosModule";
    in
    mapAttrs (_: input:
      let
        plural = input.${targetPlural} or {};
        singular =
          if input ? ${targetSingular}
          then { default = input.${targetSingular}; }
          else {};
      in
        singular // plural
    ) inputs;

  # 统一的系统构建器
  buildSystem = { inputs, self, lib, defaultUser ? "suspen", overlayList, moduleList }:
    hostName: { system, path, name ? null, home ? null, ... }:
    let
      userName = if name != null && name != "" then name else defaultUser;
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
          nixpkgs.config.allowUnfree = lib.mkDefault true;
          networking.hostName = lib.mkDefault hostName;
          user.name = lib.mkDefault userName;
          user.home = lib.mkDefault (
            if home != null then home
            else if hasSuffix "-darwin" system then "/Users/${userName}"
            else "/home/${userName}"
          );
        }
      ]
      ++ moduleList
      ++ [ path ];
      specialArgs = {
        inherit inputs self lib;
        ss = {
          modules   = platformModulesOf system inputs;
          packages  = self.packages.${system} or {};
          sourceDir = self;
          configDir = self + /config;
          keys      = import ./keys.nix;
          inherit hostName userName;
        };
      };
    };
in
{
  mkFlake = inputs@{ self, nixpkgs, ... }:
    { systems ? [ "aarch64-darwin" "x86_64-linux" "aarch64-linux" ]
    , defaultUser ? "suspen"
    , hosts ? {}
    , modules ? {}
    , overlays ? {}
    , packages ? {}
    , ...
    }@extra:
    let
      overlayList = attrValues overlays;
      moduleList = if builtins.isList modules then modules else attrValues modules;
      pkgsFor = genAttrs systems (system:
        import nixpkgs {
          inherit system;
          overlays = overlayList;
          config.allowUnfree = true;
        }
      );

      systemArgs = {
        inherit inputs self defaultUser overlayList moduleList lib;
      };
    in
    (removeAttrs extra [ "systems" "defaultUser" "hosts" "modules" "overlays" "packages" ]) // {
      inherit lib overlays;

      darwinModules = (if builtins.isAttrs modules then modules else {})
        // { default = { imports = moduleList; }; };
      nixosModules  = (if builtins.isAttrs modules then modules else {})
        // { default = { imports = moduleList; }; };

      darwinConfigurations = mapAttrs
        (buildSystem systemArgs)
        (filterAttrs (_: h: hasSuffix "-darwin" h.system) hosts);

      nixosConfigurations = mapAttrs
        (buildSystem systemArgs)
        (filterAttrs (_: h: hasSuffix "-linux" h.system) hosts);

      packages = genAttrs systems (system:
        let pkgs = pkgsFor.${system}; in
        mapAttrs (_: pkgPath: pkgs.callPackage pkgPath {}) packages
      );

      formatter = genAttrs systems (system:
        pkgsFor.${system}.nixfmt-rfc-style
      );
    };
}
