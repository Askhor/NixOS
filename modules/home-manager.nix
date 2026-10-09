{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.home-manager;
  home-manager = builtins.fetchTarball {
    url = "https://github.com/nix-community/home-manager/archive/release-26.05.tar.gz";
    sha256 = "1vy9bsc0wgz9ccgghpv4vn0z077j486il9jhrld78llf9720xsbz";
  };
in
{
  options.my.home-manager = {
    enable = mkEnableOption "home-manager";
  };
  imports = [ (import "${home-manager}/nixos") ];
  config = mkIf cfg.enable {
    home-manager.useGlobalPkgs = true;
  };
}
