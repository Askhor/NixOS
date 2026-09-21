{
  config,
  pkgs,
  lib,
  ...
}:
{
  dconf.settings = with lib.hm.gvariant; {
    "org/gnome/desktop/interface" = {
      "color-scheme" = "prefer-dark";
      "enable-hot-corners" = false;
      "current-workspace-only" = true;
    };
    "org/gnome/desktop/input-sources" = {
      sources = [
        (mkTuple [
          "xkb"
          "de+neo_qwertz"
        ])
      ];
    };
    /*
      "org/gnome/desktop/wm/keybindings" = {
      	show-desktop = ["<Super>d"];
      };
      "org/gnome/settings-daemon/plugins/media-keys" = {
      	home = ["<Super>e"];
      	screensaver = [];
      };
    */

/*    "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
      name = "Dock Broken";
      binding = "<Shift><Super>o";
      command = ''bash -c "dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys false && dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys true"'';
    };*/
  };
}
