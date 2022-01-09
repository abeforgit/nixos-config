{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.tmux;
in {
  options.custom.tmux = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {
      programs.tmux = {
        enable = true;
        keyMode = "vi";
        prefix = "C-w";
        escapeTime = 0;
        baseIndex = 1;
        tmuxinator = { enable = true; };
        plugins = with pkgs; [
          tmuxPlugins.sensible
          tmuxPlugins.vim-tmux-navigator
        ];
        extraConfig = ''
          bind k send-keys -t.- 'tmkill' Enter
          bind v split-window -h -c "#{pane_current_path}"
          bind s split-window -v -c "#{pane_current_path}"
          bind o resizep -Z
          bind ` ls
          bind e detach

          #switch panels
          bind k selectp -U # switch to panel Up
          bind j selectp -D # switch to panel Down
          bind h selectp -L # switch to panel Left
          bind l selectp -R # switch to panel Right
          bind d killp  # switch to panel Right

          bind-key -T copy-mode-vi 'v' send -X begin-selection
          bind-key -T copy-mode-vi 'y' send -X copy-pipe 'xclip -i -sel p -f | xclip -i -sel c' # List of plugins


          # mouse support
          set -g mouse on

          # styling
          set -g status-bg black
          set -g status-fg white

          set -g status-right ""
          set -g status-left ""

          set -g status-justify centre

          set -g window-status-current-format "#[fg=magenta]#[fg=black]#[bg=magenta]#I #[bg=brightblack]#[fg=white] #W#[fg=brightblack]#[bg=black] "
          set -g window-status-format "#[fg=yellow]#[fg=black]#[bg=yellow]#I #[bg=brightblack]#[fg=white] #W#[fg=brightblack]#[bg=black] "

          # turn on window titles
          set -g set-titles on

          # set wm window title string
          set -g set-titles-string '#S'

          # automatically set window title
          setw -g automatic-rename on
          set -g focus-events on
        '';
      };
    };

  };

}
