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
    sha256 = "0y9xxavks8m1a0q50cn9zz5wjw3c3dcqklvv0b3qs9lfg02ijss7";
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
