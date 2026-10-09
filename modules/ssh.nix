{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.ssh;
in
{
  options.my.ssh = {
    enable = mkEnableOption "default ssh config";
  };
  config = lib.mkIf cfg.enable {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "guenthner.xyz" = {
          HostName = "87.106.77.210";
          User = "j";
        };
        "test" = {
          HostName = "217.154.245.104";
          User = "joni";
        };
      };
    };
  };
}
