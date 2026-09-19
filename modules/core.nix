# modules/core.nix --- Core dotfiles module (user alias & global options)
{ lib, options, config, ... }:

{
  options = {
    modules = {};

    # Creates a simpler, polymorphic alias for users.users.$USER.
    user = lib.mkOption {
      type = options.users.users.type.nestedTypes.elemType;
      default = {};
      description = "The primary user account configuration";
    };
  };

  config = {
    assertions = [{
      assertion = config.user.name != "";
      message = "config.user.name must not be empty!";
    }];

    users.users.${config.user.name} = lib.mkAliasDefinitions options.user;
  };
}

