{ config, lib, ... }:
with lib;
let
  cfg = config.my.bash;
in
{
  options.my.bash = {
    enable = mkEnableOption "my bash config";
  };
  config = mkIf cfg.enable {
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

        set +o histexpand # Disable history expansion!
      '';
      logoutExtra = "echo Goodbye!";
      sessionVariables = {
        # MANPAGER = "bash -c 'ansifilter -T | bat -l man --style=plain'";
      };
      shellAliases = {
        ".." = "cd ..";
      };
    };
  };
}
