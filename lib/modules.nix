{ lib }:

let
  inherit (builtins) isPath pathExists readDir;
  inherit (lib) attrValues concatMapAttrs filterAttrs hasPrefix hasSuffix id mapAttrs removeSuffix;

  isModuleFile = n: v:
    v == "regular"
    && n != "default.nix"
    && n != "flake.nix"
    && hasSuffix ".nix" n;

  toPath = p: if isPath p then p else /. + toString p;

in rec {
  # 统一的目录扫描器：
  # 1. 入口处对 dir 做一次 toPath 和 pathExists 安全防护；
  # 2. 内部 walk 直接闭包捕获 fn 并自递归，避免无意义的高阶回调与冗余 stat；
  # 3. 遇到含 default.nix 的目录作为组件收纳（如 packages）；
  # 4. 遇到无 default.nix 的目录向下下潜拼接 key（如 modules/shell/）。
  mapModules = dir: fn:
    let
      dirPath = toPath dir;
      walk = prefix: path:
        concatMapAttrs (n: v:
          let
            sub = path + "/${n}";
            key = if prefix == "" then n else "${prefix}/${n}";
          in
          if hasPrefix "_" n then {}
          else if v == "directory" then
            if pathExists (sub + "/default.nix")
            then { ${key} = fn sub; }
            else walk key sub
          else if isModuleFile n v then
            { ${removeSuffix ".nix" key} = fn sub; }
          else {}
        ) (readDir path);
    in
      if pathExists dirPath then walk "" dirPath else {};

  # 列表形式变体
  mapModules' = dir: fn:
    attrValues (mapModules dir fn);

  mapHosts = dir:
    let dirPath = toPath dir; in
    mapAttrs (hostName: _:
      let meta = import (dirPath + "/${hostName}/meta.nix"); in {
        inherit hostName;
        inherit (meta) system;
        name = meta.name or null;
        home = meta.home or null;
        path = dirPath + "/${hostName}";
      }
    ) (filterAttrs (n: v: 
        v == "directory" 
        && !(hasPrefix "_" n) 
        && pathExists (dirPath + "/${n}/meta.nix")
      ) (readDir dirPath));
}
