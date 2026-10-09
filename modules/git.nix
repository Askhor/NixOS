{
  config,
  pkgs,
  lib,
  ...
}:
with lib;
let
  cfg = config.my.git;
in
{
  options.my.git = {
    enable = mkEnableOption "default git config";
  };
  config = lib.mkIf cfg.enable {
    programs.gh.enable = true;
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
  };
}
