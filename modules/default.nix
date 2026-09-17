{ ss, lib, options, config, ... }:

with lib;
with ss;

let
  ssLib = import ../lib { inherit lib; };
in {
  imports = ssLib.mapModulesRec' ./. (p: p);

  options = with types; {
    modules = {};

    # Creates a simpler, polymorphic alias for users.users.$USER.
    user = mkOption {
      type =
        let elemType = options.users.users.type.nestedTypes.elemType;
        in elemType.substSubModules (elemType.getSubModules ++ [
             { config.name = mkOverride 500 ""; }
           ]);
      default = {};
      description = "The primary user account configuration";
    };
  };

  config = {
    assertions = [{
      assertion = config.user.name != "";
      message = "config.user.name must be explicitly set in the host configuration!";
    }];

    users.users.${config.user.name} = mkAliasDefinitions options.user;
  };
}

