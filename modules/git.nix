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

        programs.delta = {
          enable = true;
          package = pkgs.delta;
	  enableGitIntegration = true;
        };
        programs.git = {
          enable = true;
          settings = {
            user.name = "abeforgit";
            user.email = "arnebertrand@gmail.com";
            merge.conflictstyle = "diff3";
            rerere.enabled = true;
            github.user = "abeforgit";
          };
          lfs.enable = true;
          ignores = [
            ".direnv"
            ".envrc"
            ".idea/*"
            "*.iml"
          ];
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
            # version = 1;
            editor = "nvim";
            git_protocol = "ssh";
            prompt = "enabled";
          };
        };
      };

  };

}
