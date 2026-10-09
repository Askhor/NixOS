{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.sound;
in
{
  options.my.sound = {
    enable = mkEnableOption "Enable sound support";
  };
  config = lib.mkIf cfg.enable {
    # Enable sound with pipewire.
    services.pulseaudio.enable = false;
    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      # If you want to use JACK applications, uncomment this
      # jack.enable = true;
    };
  };
}
