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
      default = 4;
      description = "The number of virtual cores";
    };
  };
  config = mkIf cfg.enable {
    virtualisation.vmVariant = {
      # the following configuration is added only when building VM with `build-vm`
      virtualisation = {
        memorySize = cfg.memory;
        cores = cfg.cores;
      };
    };
  };
}
