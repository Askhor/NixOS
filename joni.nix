{ config, pkgs, ... }:
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
      #  thunderbird
      borgbackup
      keepassxc
      nixfmt
      signal-desktop
      vlc
      fastfetch
    ];
  };

  home-manager.useGlobalPkgs = true;
  home-manager.users.joni = {
    # The home.stateVersion option does not have a default and must be set
    home.stateVersion = "26.05";

    programs.git = {
      enable = true;
      settings = {
        user = {
          name = "Joni";
          email = "j@guenthner.xyz";
        };
      };
    };
  };
}
