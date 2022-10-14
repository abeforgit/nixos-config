{ pkgs, config, lib, activitywatch, ... }:
with lib;
let cfg = config.custom.herbstluft;
in {
  imports = [ ./polybar.nix ];
  options.custom.herbstluft = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.polybar.enable = true;
    services.xserver.windowManager.herbstluftwm = { enable = true; };
    services.xserver = {
      enable = true;
      displayManager = {

        defaultSession = "xfce";
        lightdm.greeters.gtk.cursorTheme.name = "Qogir";
        lightdm.greeters.gtk.cursorTheme.package = pkgs.qogir-icon-theme;
      };
      desktopManager = {
        xterm.enable = false;
        xfce = {
          enable = true;
          noDesktop = false;
          enableXfwm = true;
        };
      };
    };
    services.dbus = {
      enable = true;
      # packages = with pkgs; [

      #   xfce.xfce4-panel
      #   xfce.xfdashboard
      #   xfce.xfce4-session
      # ];
    };
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        fira-code
        tdrop
        wmname
        xorg.xwininfo
        xdotool
        acpilight
        xfce.xfdashboard
        lxappearance
        ant-theme
        plano-theme
        juno-theme
        qogir-theme
        qogir-icon-theme
      ];

      programs.rofi = {
        enable = true;
        font = "Fira Code 24";
        theme = "Monokai";
        extraConfig = {
          modi = "combi,drun,ssh";
          combi-modi = "window,drun,run";
          kb-row-down = "Down,Control+j";
          kb-row-up = "Up,Control+k";
          kb-remove-to-eol = "";
          kb-accept-entry = "Return,KP_Enter";
          window-thumbnail = true;
          window-command = "herbstclient bring {window}";
        };
      };
      services.flameshot = { enable = true; };

      home.file."reload-wm" = {
        source = ./reload-wm.sh;
        executable = true;
        target = ".local/bin/reload-wm";
      };
      home.file."swap-window" = {
        source = ./swap-window.sh;
        executable = true;
        target = ".local/bin/swap-window";
      };
      services.sxhkd = {
        enable = true;
        keybindings = let hc = "herbstclient";
        in {
          "super + shift + q" = "${hc} close_and_remove";
          "super + Return" =
            "tdrop -m -a -w 98% -x 1% -h 60% --class org.wezfurlong.wezterm wezterm";
          "super + shift + Return" = "wezterm";
          "super + w; {s,v}" = "${hc} split {bottom, right} 0.5";
          "super + w; d" = "${hc} remove";
          "super + e" = ''
            ${hc} chain , rule maxage=0.5 label=temp floating=on , spawn emacsclient --eval "(emacs-everywhere)"'';

          "super + p" = "${hc} cycle -1";
          "super + n" = "${hc} cycle +1";
          # "super + space; b; n" = "focus-last";
          "super + space; r; s" = "pkill -USR1 -x sxhkd";
          "super + space; r; r" = "reload-wm";
          # "super + {1-5}" = "bspc desktop -f '{I,II,III,IV,V}'";
          # "super + w; {1-5}" = "bspc node -d '{I,II,III,IV,V}'";
          # "super + space; b ; b" = "swap-window";
          "super + space; super + space" = "rofi -show combi";
          "super + d" = "${hc} remove";
          "super + b" = "rofi -show combi";
          # "super + Escape" =
          #   "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
          # "super + space; b; {p,n}" = ''
          #     bspc wm -h off ;\
          #   	bspc node -s {older,newer} ;\
          #     bspc wm -h on;
          # '';
          "ctrl + alt + Delete ; {p, e, r, s, h, l}" =
            "lockmgr {shutdown,logout,reboot,suspend,hibernate,lock}";
          # "super + alt + {q,r}" = "bspc {quit,wm -r}";
          # "super + m" = "bspc desktop -l next";
          # "super + y" =
          #   "bspc node newest.marked.local -n newest.!automatic.local";
          # "super + g" = "bspc node -s biggest";
          # "super + {t,shift + t,f}" =
          #   "bspc node -t {tiled,pseudo_tiled,'~fullscreen'}";
          # "super + shift + space" = "bspc node -t '~floating'";
          # "super + ctrl + {m,x,y,z}" =
          #   "bspc node -g {marked,locked,sticky,private}";
          # "super + {_,shift + }{h,j,k,l}" =
          #   "bspc node -{f,s} {west,south,north,east}";
          # "super + {a,comma,period}" = "bspc node -f @{parent,first,second}";
          # "super + {_,shift + }Tab" = "bspc node -f {next,prev}.local";
          # "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
          # "super + {o,i}" = ''
          #     bspc wm -h off; \
          #   	bspc node {older,newer} -f; \
          #   	bspc wm -h on
          # '';
          # "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
          # "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
          # "super + ctrl + space" = "bspc node -p cancel";
          # "super + ctrl + shift + space" =
          #   "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
          # "super + alt + {h,j,k,l}" =
          #   "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
          # "super + alt + shift + {h,j,k,l}" =
          #   "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
          # "super + {Left,Down,Up,Right}" =
          #   "bspc node -v {-20 0,0 20,0 -20,20 0}";
          # "super + space ; t" = "tdrop -ma -w -5 -h 60% --wm bspwm  kitty";
          "super + F12" =
            "tdrop -m -a -h 60% -n 1  --class Chromium-browser chromium --app=https://chat.semte.ch";
          "super + F11" =
            "tdrop -m -a -h 60% -n 2  --class Chromium-browser chromium --app=https://mattermost.zeus.gent";
          "super + F10" =
            "tdrop -m -a -h 60% -n 3 --class Chromium-browser chromium --app=https://track.toggl.com/timer";
          "super + F9" = "flameshot gui";
          "super + {grave}" =
            "tdrop -m -a -n emacs --wm herbstluftwm -h 60% --class Emacs emacs";
          "XF86MonBrightnessUp" = "xbacklight -inc 20";
          "XF86MonBrightnessDown" = "xbacklight -dec 20";
          "XF86AudioRaiseVolume" = "pactl set-sink-volume 0 +5%";
          "XF86AudioLowerVolume" = "pactl set-sink-volume 0 -5%";
          "XF86AudioMute" = "pactl set-sink-mute 0 toggle";
          "XF86AudioPlay" = "playerctl play";
          "XF86AudioPause" = "playerctl pause";
          "XF86AudioNext" = "playerctl next";
          "XF86AudioPrev" = "playerctl previous";
          "Print" = "flameshot gui";
          # "super + o; f" = "thunar";
        };
      };
    };
  };
}
