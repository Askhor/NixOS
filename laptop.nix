{ config, pkgs, ... }:
{
  imports = [
    "/etc/nixos/hardware-configuration.nix"
    ./modules/home-manager.nix
    ./modules/time_locale.nix
    ./modules/sound.nix
    ./modules/virtualisation.nix
  ];
  nixpkgs.config.allowUnfree = true;
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };
  networking = {
    networkmanager.enable = true;
    hostName = "nixos";
  };
  services.printing.enable = true;
  programs.firefox.enable = true;
  environment.systemPackages = with pkgs; [
    tree
    file
    zip
    unzip
    dconf
    gnomeExtensions.appindicator
    gnomeExtensions.dash-to-dock
    gnomeExtensions.user-themes
    gnomeExtensions.gtk4-desktop-icons-ng-ding
    mullvad
  ];
  services.gnome.core-apps.enable = true;
  services.gnome.core-developer-tools.enable = true;
  services.gnome.games.enable = false;
  environment.gnome.excludePackages = with pkgs; [
    gnome-tour
    gnome-user-docs
    gnome-weather
    gnome-contacts
  ];

  services.displayManager.gdm.enable = true;
  services.desktopManager.gnome.enable = true;

  services.xserver.xkb = {
    layout = "de";
    variant = "neo_qwertz";
  };
  console.keyMap = "de";

  users.users."joni" = {
	enable = true;
	hashedPassword = "$6$wIz/v3Mt39c.35An$hOl44DmZL8P.ymDMM9MnIEAHIuAMyq3DJZ4gkDhOAWXEZdCtnGRRkcBMQdVbwxKS2Hy87LLSbpMBsXFamOTDj/";
    isNormalUser = true;
    description = "Joni";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      # borgbackup
      keepassxc
      nixfmt
      signal-desktop
      vlc
      fastfetch
      ansifilter
      bat
      tor-browser
      qbittorrent
      clamav
      sqlitebrowser
    ];
  };
  my = {
  	home-manager.enable = true;
  	time_locale.enable = true;
  	virtualisation.enable = true;
  	sound.enable = true;
  };
  home-manager.users.joni = {
    	home.stateVersion = "26.05";
    	imports = [
    		./modules/bash.nix
    		./modules/git.nix
    		./modules/ssh.nix
    	];
    	my = {
    		bash.enable = true;
    		git.enable = true;
    		ssh.enable = true;
    	};
  };
  programs.git = {
      enable = true;
      config = {
        init.defaultBranch = "main";
      };
    };
      programs.firefox = {
      enable = true;
      languagePacks = [
        "en-GB"
        "en"
        "de"
      ];
      policies = {
        DefaultDownloadDirectory = "\${home}/downloads";
        ExtensionSettings = {
          /*
            "uBlock0@raymondhill.net" = {
              default_area = "menupanel";
              install_url = "https://addons.mozilla.org/firefox/downloads/latest/ublock-origin/latest.xpi";
              installation_mode = "force_installed";
              private_browsing = true;
            };
          */
        };
      };
    };
     xdg = {
      userDirs =
        let
          home = "/home/joni";
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
        entries = with pkgs; [
          "${signal-desktop}/share/applications/signal.desktop"
        ];
      };
    };

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

    /*
      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
         name = "Dock Broken";
         binding = "<Shift><Super>o";
         command = ''bash -c "dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys false && dconf write /org/gnome/shell/extensions/dash-to-dock/hot-keys true"'';
       };
    */
  };
  system.stateVersion = "26.05";
  
  /*systemd.services.daily-backup = if builtins.pathExists /home/joni/.config/borg_passphrase then {
    description = "Daily Backup";

    script = ''
      		set -eu
      		echo hiiii
      		cat /home/joni/.config/borg_passphrase
      	'';

    serviceConfig = {
      Type = "oneshot";
      User = "joni";
    };

    path = [ pkgs.borgbackup ];
  } else abort "fuck";*/
}
