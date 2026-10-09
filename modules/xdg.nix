{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.xdg;
in
{
  options.my.xdg = {
    enable = mkEnableOption "my xdg config";
    user = mkOption {
      type = types.str;
      default = "joni";
    };
  };
  config = mkIf cfg.enable {
    xdg = {
      userDirs =
        let
          home = "/home/${cfg.user}";
        in
        {
          enable = true;
          desktop = "${home}/desktop";
          download = "${home}/downloads";
          videos = "${home}/media";
          pictures = home;
          templates = home;
          documents = home;
          projects = home;
          music = "${home}/files/music";
          createDirectories = false;
        };
      autostart = {
        enable = true;
        readOnly = true;
        entries = [
          "${pkgs.signal-desktop}/share/applications/signal.desktop"
        ];
      };
    };
  };
}
