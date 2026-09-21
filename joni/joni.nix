{
  config,
  pkgs,
  lib,
  ...
}:
let
  home-manager = builtins.fetchTarball "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
in
{
  imports = [
    (import "${home-manager}/nixos")
  ];

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users."joni" = {
    isNormalUser = true;
    description = "Joni";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      borgbackup
      keepassxc
      nixfmt
      signal-desktop
      vlc
      fastfetch
      ansifilter
      bat
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.joni = {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "26.05";

    imports = [
      ./dconf.nix
    ];

    /*
      programs.gpg = {
      	enable = true;
      };
    */

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        "guenthner.xyz" = {
          HostName = "87.106.77.210";
          User = "j";
        };
      };
    };

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Joni";
          email = "j@guenthner.xyz";
        };
        status = {
          short = true;
        };
        alias = {
          last = "log -1 HEAD";
          s = "status";
        };
        gpg.ssh = {
          allowedSignersFile = builtins.toFile "allowed_signers" ''
            		j@guenthner.xyz namespaces="git" ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc1okn5N3hMJinTPAlbGWeBq7olIEsRDQcSar20r42C
            	'';
        };
      };
      signing = {
        format = "ssh";
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc1okn5N3hMJinTPAlbGWeBq7olIEsRDQcSar20r42C j-guenthner@guenthner";
        # allowedSigners = ''ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc1okn5N3hMJinTPAlbGWeBq7olIEsRDQcSar20r42C j-guenthner@guenthner'';
        signByDefault = true;
      };
    };

    programs.gh = {
      enable = true;
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

    programs.bash = {
      enable = true;
      historyControl = [
        "erasedups"
        "ignorespace"
      ];
      historyIgnore = [
        "ls"
        "cd"
        "exit"
        "git status"
        "clear"
        "history"
      ];
      initExtra = ''
        function list-commands() {
        	  compgen -c
        }

        # Key bindings

        bind -x '"\C-l":clear'
        # bind '"\C-f":"chomp\C-M"'
        bind '"\C-u":"cd ..\C-M"'
        # bind '\C-t':undo
        bind -x '"\C-e":bash -c "nautilus . &> /dev/null"'
      '';
      logoutExtra = "echo Goodbye!";
      sessionVariables = {
        # MANPAGER = "bash -c 'ansifilter -T | bat -l man --style=plain'";
      };
      shellAliases = {
        ".." = "cd ..";
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
          download = "${home}/download";
          videos = "${home}/media";
          pictures = home;
          templates = home;
          documents = home;
          projects = home;
          music = "${home}/files/music";
          createDirectories = false;
        };
    };
  };
}
