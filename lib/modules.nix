{ lib }:

let
  inherit (builtins) attrValues readDir pathExists;
  inherit (lib) attrNames concatMap concatMapAttrs filter filterAttrs hasPrefix hasSuffix id mapAttrs
                removeSuffix;

  isModuleFile = n: v:
    v == "regular"
    && n != "default.nix"
    && n != "flake.nix"
    && hasSuffix ".nix" n;

  walk = onDir: dir: fn:
    let dir' = toString dir; in
    concatMapAttrs
      (n: v:
        let path = "${dir'}/${n}"; in
        if hasPrefix "_" n then {}
        else if v == "directory" then onDir n path fn
        else if isModuleFile n v then { ${removeSuffix ".nix" n} = fn path; }
        else {})
      (readDir dir');
in rec {
  mapModules =
    walk (n: path: fn:
      if pathExists "${path}/default.nix"
      then { ${n} = fn path; }
      else {});

  mapModules' = dir: fn:
    attrValues (mapModules dir fn);

  mapModulesRec =
    walk (n: path: fn: { ${n} = mapModulesRec path fn; });

  modulePaths = dir:
    let
      dir' = toString dir;
      entries = readDir dir';
      subdirs =
        filter
          (n: entries.${n} == "directory" && !(hasPrefix "_" n))
          (attrNames entries);
    in
      attrValues (mapModules dir' id)
      ++ concatMap (n: modulePaths "${dir'}/${n}") subdirs;

  mapModulesRec' = dir: fn:
    map fn (modulePaths dir);

  mapHosts = dir:
    let
      entries = readDir dir;
      archDirs = filterAttrs (sys: type:
        type == "directory" && (hasSuffix "-darwin" sys || hasSuffix "-linux" sys)
      ) entries;
    in
      concatMapAttrs (system: _:
        mapAttrs (hostName: _: {
          inherit system;
          path = dir + "/${system}/${hostName}";
        }) (filterAttrs (n: type: type == "directory" && !(hasPrefix "_" n)) (readDir (dir + "/${system}")))
      ) archDirs;
}
