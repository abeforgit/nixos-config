{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.nushell;
in {
  options.custom.nushell = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {
      programs.nushell = {
        enable = true;
        configFile.source = ./config.nu;

        # shellAliases = {
        #   mux = "tmuxinator";
        #   docker-stopall = "docker stop $(docker ps -q)";
        #   mucli = "~/repos/redpencil/mu-cli/mu";
        #   emc = "emacsclient -nw";

        #   gmdh = ''git log --pretty=format:"%s%n%b" development..HEAD'';
        #   gitmsg = ''git log --pretty=format:"%s%n%b'';
        #   ls = "lsd";
        #   lt = "lsd --tree";
        #   grep = "grep --colour=auto";
        #   egrep = "egrep --colour=auto";
        #   fgrep = "fgrep --colour=auto";
        #   cp = "cp -i";
        #   df = "df -h";
        #   free = "free -m";
        #   ipa = "ip -c=auto a";
        #   ip4 = "ip -c=auto -br -4 a";
        #   ip6 = "ip -c=auto -br -6 a";
        #   lsizes = "sudo du -hsx .[!.]* * | sort -rh";
        #   pgrep = "pgrep -l";
        #   gits = "git status";
        #   gg =
        #     "git log --graph --pretty=format:'%C(bold)%h%Creset%C(magenta)%d%Creset %C(yellow)<%an> %C(cyan)(%cr)%Creset' --abbrev-commit --date=relative";
        #   gc = "git checkout";
        #   ghprc = "gh pr ls | fzf | cut -f 1 | xargs gh pr checkout";
        #   extip = "curl ifconfig.co";
        #   icat = "kitty +kitten icat";
        #   rebuild =
        #     "nixos-rebuild --flake ~/repos/nixos-config#finch switch --use-remote-sudo";
        #   checkbuild =
        #     "nixos-rebuild --flake ~/repos/nixos-config#finch build and nvd diff /run/current-system ~/repos/nixos-config/result";
        #   srcrc = "source ~/.zshrc";
        # };
      };
      programs.starship = {
        enable = true;
        enableNushellIntegration = true;
      };
      programs.direnv = {
        enable = true;
        enableNushellIntegration = true;
        nix-direnv.enable = true;
      };
      programs.zoxide = {
        enable = true;
        enableNushellIntegration = true;
      };
      programs.fzf = {
        enable = true;
      };
      programs.atuin = {
        enable = true;
        enableNushellIntegration = true;
      };
    };
  };
}
