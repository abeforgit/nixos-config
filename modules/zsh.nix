{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.zsh;
in {
  options.custom.zsh = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    environment.pathsToLink = [ "/share/zsh" ];
    custom.tmux.enable = true;
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {

      programs.starship = {
        enable = true;
        enableZshIntegration = true;
      };
      programs.lsd = { enable = true; };
      programs.direnv = {
        enable = true;
        enableZshIntegration = true;
        nix-direnv.enable = true;
      };
      programs.zoxide = {
        enable = true;
        enableZshIntegration = true;
        options = ["--cmd j"];
      };
      programs.fzf = {
        enable = true;
        enableZshIntegration = true;
      };

      programs.zsh = {
        enable = true;
        enableCompletion = true;
        enableAutosuggestions = true;
        enableSyntaxHighlighting = true;
        defaultKeymap = "viins";

        zplug = {
          enable = true;
        };
        oh-my-zsh = {
          enable = true;
          plugins = [
            "docker"
            "docker-compose"
            "npm"
            "tmux"
            "vi-mode"
          ];
        };
        shellAliases = {
          mux = "tmuxinator";
          docker-stopall = "docker stop $(docker ps -q)";
          ssh = "kitty +kitten ssh";
          mucli = "~/repos/redpencil/mu-cli/mu";

          gmdh = ''git log --pretty=format:"%s%n%b" development..HEAD'';
          gitmsg = ''git log --pretty=format:"%s%n%b'';
          ls = "lsd";
          lt = "lsd --tree";
          grep = "grep --colour=auto";
          egrep = "egrep --colour=auto";
          fgrep = "fgrep --colour=auto";
          cp = "cp -i";
          df = "df -h";
          free = "free -m";
          ipa = "ip -c=auto a";
          ip4 = "ip -c=auto -br -4 a";
          ip6 = "ip -c=auto -br -6 a";
          lsizes = "sudo du -hsx .[!.]* * | sort -rh";
          pgrep = "pgrep -l";
          gits = "git status";
          gg =
            "git log --graph --pretty=format:'%C(bold)%h%Creset%C(magenta)%d%Creset %C(yellow)<%an> %C(cyan)(%cr)%Creset' --abbrev-commit --date=relative";
          gc = "git checkout";
          extip = "curl ifconfig.co";
          icat = "kitty +kitten icat";
          rebuild =
            "sudo nixos-rebuild switch --flake ~/repos/nixos-config#finch";
        };
      };
    };
  };

}
