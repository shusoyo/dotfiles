{ config, lib, ss, ... }:

let
  cfg = config.services.cliproxyapi;
  isDarwin = lib.hasSuffix "-darwin" ss.system;
  isLinux = lib.hasSuffix "-linux" ss.system;
  defaultStateDir = "${config.home.homeDirectory}/.local/state/cliproxyapi";
  staticDir = "${defaultStateDir}/static";
  configPath = toString cfg.configFile;
  configDir = builtins.dirOf configPath;
  logsDir = "${defaultStateDir}/logs";
  stdoutPath = "${logsDir}/stdout.log";
  stderrPath = "${logsDir}/stderr.log";
  execArgs = [
    "${cfg.package}/bin/cli-proxy-api"
    "-config"
    configPath
  ];
in
{
  options.services.cliproxyapi = {
    enable = lib.mkEnableOption "CLIProxyAPI user service";

    package = lib.mkOption {
      type = lib.types.nullOr lib.types.package;
      default = null;
      description = "CLIProxyAPI package to run for the user service.";
    };

    configFile = lib.mkOption {
      type = lib.types.either lib.types.path lib.types.str;
      example = "/Users/alice/.config/cliproxyapi/config.yaml";
      description = "Path to the CLIProxyAPI config file that should be read directly.";
    };
  };

  config = lib.mkIf cfg.enable (
    {
      assertions = [
        {
          assertion = cfg.package != null;
          message = "services.cliproxyapi.package must be set when enabling CLIProxyAPI.";
        }
      ];

      home.activation.cliproxyapi = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
        mkdir -p "${defaultStateDir}" "${defaultStateDir}/auth" "${logsDir}" "${staticDir}" "${configDir}"
      '';
    }
    // lib.optionalAttrs isDarwin {
      launchd.agents.cliproxyapi = {
        enable = true;
        config = {
          Label = "org.nix-community.cliproxyapi";
          ProgramArguments = execArgs;
          RunAtLoad = true;
          KeepAlive = true;
          WorkingDirectory = builtins.dirOf configPath;
          ProcessType = "Interactive";
          StandardOutPath = stdoutPath;
          StandardErrorPath = stderrPath;
          EnvironmentVariables = {
            HOME = config.home.homeDirectory;
            MANAGEMENT_STATIC_PATH = staticDir;
          };
        };
      };
    }
    // lib.optionalAttrs isLinux {
      systemd.user.services.cliproxyapi = {
        Unit = {
          Description = "CLIProxyAPI user service";
          After = [ "network-online.target" ];
          Wants = [ "network-online.target" ];
        };

        Service = {
          ExecStart = lib.escapeShellArgs execArgs;
          WorkingDirectory = builtins.dirOf configPath;
          Restart = "on-failure";
          RestartSec = "5";
          Environment = [
            "HOME=${config.home.homeDirectory}"
            "MANAGEMENT_STATIC_PATH=${staticDir}"
          ];
        };

        Install = {
          WantedBy = [ "default.target" ];
        };
      };
    }
  );
}
