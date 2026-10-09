{ lib, config, ... }:
with lib;
let
  cfg = config.my.virtualisation;
in
{
  options.my.virtualisation = {
    enable = mkEnableOption "Enable Default Settings for virtualisation";
    memory = mkOption {
      type = types.int;
      default = 4096;
      description = "The size of memory in MB";
    };
    cores = mkOption {
      type = types.int;
      default = 7;
      description = "The number of virtual cores";
    };
    graphics = mkOption {
      type = types.bool;
      default = true;
    };
  };
  config = mkIf cfg.enable {
    virtualisation.vmVariant = {
      # the following configuration is added only when building VM with `build-vm`
      virtualisation = {
        memorySize = cfg.memory;
        cores = cfg.cores;
        forwardPorts = [
          {
            from = "host";
            host.port = 2222;
            guest.port = 22;
          }
        ];
        graphics = cfg.graphics;
      };
    };
  };
}
