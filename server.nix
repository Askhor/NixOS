{
  config,
  pkgs,
  lib,
  ...
}:
{
  imports = [
    ./server-hardware-configuration.nix
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
  services.openssh = {
    enable = true;
    openFirewall = true;
    settings = {
      PasswordAuthentication = false;
      KbdInteractiveAuthentication = false;
      PermitRootLogin = "no";
      AllowUsers = [ "joni" ];
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
    openssh.authorizedKeys.keys = [
      "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINc1okn5N3hMJinTPAlbGWeBq7olIEsRDQcSar20r42C joni@nixos"
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
  boot.initrd.availableKernelModules = [
    "virtio_pci"
    "virtio_blk"
    "virtio_scsi"
    "ahci"
    "sd_mod"
  ];
  system.stateVersion = "26.05";

}
