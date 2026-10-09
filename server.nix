{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./modules/home-manager.nix
    ./modules/time_locale.nix
    ./modules/virtualisation.nix
  ];
  nixpkgs.config.allowUnfree = true;
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  nix.gc = {
    automatic = true;
    dates = "daily";
    options = "--delete-older-than 10d";
  };
  networking = {
    networkmanager.enable = true;
    hostName = "nixos-server";
  };
  services.openssh = { # ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc1okn5N3hMJinTPAlbGWeBq7olIEsRDQcSar20r42C j-guenthner@guenthner
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "joni" ];
      MaxAuthTries = 3;
      PerSourcePenalties = "crash:3600s authfail:3600s max:86400s";
    };
  };
  environment.systemPackages = with pkgs; [
    tree
    file
    zip
    unzip
  ];
  services.gnome.core-apps.enable = false;
  services.gnome.core-developer-tools.enable = false;
  services.gnome.games.enable = false;
  services.displayManager.gdm.enable = false;
  services.desktopManager.gnome.enable = false;

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
      fastfetch
      bat
    ];
  };

  my = {
    home-manager.enable = true;
    time_locale.enable = true;
    virtualisation = {
      enable = true;
      cores = 1;
      memory = 500;
      graphics = false;
    };
  };
  home-manager.users.joni = {
    home.stateVersion = "26.05";
    imports = [
      ./modules/bash.nix
    ];
    my = {
      bash.enable = true;
    };
  };
  system.stateVersion = "26.05";

}
