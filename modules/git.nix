{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.git;

in {
  imports = [ ./nvim.nix ];
  options = {
    custom.git.enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.nvim.enable = true;
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {
      programs.git = {
        enable = true;
        userName = "abeforgit";
        userEmail = "arnebertrand@gmail.com";
        delta.enable = true;
        lfs.enable = true;
        ignores = [ ".direnv" ".envrc" "shell.nix" ".idea/*" "*.iml" ];
        extraConfig = {
          merge.conflictstyle = "diff3";
          rerere.enabled = true;

        };
      };
      programs.gh = {
        enable = true;
        settings = {
          editor = "emacs";
          git_protocol = "ssh";
          prompt = "enabled";
        };
      };
    };

  };

}
