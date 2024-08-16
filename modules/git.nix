{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.custom.git;

in
{
  imports = [ ./nvim.nix ];
  options = {
    custom.git.enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.nvim.enable = true;
    home-manager.users.${config.custom.user} =
      { pkgs, home, ... }:
      {

        programs.git = {
          enable = true;
          userName = "abeforgit";
          userEmail = "arnebertrand@gmail.com";
          delta = {
            enable = true;
            package = pkgs.delta;
          };
          lfs.enable = true;
          ignores = [
            ".direnv"
            ".envrc"
            ".idea/*"
            "*.iml"
          ];
          extraConfig = {
            merge.conflictstyle = "diff3";
            rerere.enabled = true;
            github.user = "abeforgit";
          };
          includes = [
            {
              condition = "gitdir:~/repos/redpencil/";
              # path = "~/repos/redpencil/.work_config";
              contents = {
                core = {
                  excludesFile = builtins.toFile "work-ignore" ''
                    .direnv
                    .envrc
                    .idea/*
                    *.iml
                    flake.nix
                    devshell.toml
                    shell.nix
                  '';

                };
              };
            }
          ];
        };
        programs.gh = {
          enable = true;
          settings = {
            # Workaround for https://github.com/nix-community/home-manager/issues/4744
            version = 1;
            editor = "emacs";
            git_protocol = "ssh";
            prompt = "enabled";
          };
        };
      };

  };

}
