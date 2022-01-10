# takes care of graphical env
{ pkgs, config, lib, ... }:
with lib;
let cfg = config.custom.bspwm;
in {
  imports = [ ./polybar.nix ];
  options.custom.bspwm = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.polybar.enable = true;
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ fira-code tdrop wmname ];
      xsession = {
        enable = true;
        windowManager.bspwm = {
          enable = true;
          settings = {
            border_width = 10;
            window_gap = 12;
            split_ratio = 0.52;
            borderless_monocle = true;
            gapless_monocle = true;
            focus_follows_pointer = true;
            pointer_follows_monitor = true;

          };
          monitors = {
            "^1" = [ "I" "__" ];
            "^2" = [ "II" ];
          };
          rules = {
            Emacs = { state = "tiled"; };
            "__scratch:scratch" = { state = "floating"; };
            Peek = { state = "floating"; };
          };
          startupPrograms = [ "wmname LG3D" ];
        };
        scriptPath = ".hm-xsession";
      };

      programs.rofi = {
        enable = true;
        font = "Fira Code 24";
        theme = "Monokai";
      };
      services.flameshot = { enable = true; };

      services.sxhkd = {
        enable = true;
        keybindings = {
          "super + {1-2}" = "bspc desktop -f '{I,II}'";
          "super + w; {s,v}" = "bspc node -p {south,east}";
          "super + w; {1-2}" = "bspc node -d '{I,II}'";
          "super + w; d" = "bspc node -d __";
          "super + space; b ; b" = "swap-window";
          "super + space; super + space" = "swap-window";
          "super + d" = "rofi -show combi";
          "super + Escape" =
            "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
          "super + space; r; s" = "pkill -USR1 -x sxhkd";
          "super + space; b; {p,n}" = ''
              bspc wm -h off ;\
            	bspc node -s {older,newer} ;\
              bspc wm -h on;
          '';
          "ctrl + alt + Delete ; {p, e, r, s, h, l}" =
            "lockmgr {shutdown,logout,reboot,suspend,hibernate,lock}";
          "super + alt + {q,r}" = "bspc {quit,wm -r}";
          "super + shift + q" = "bspc node -c";
          "super + m" = "bspc desktop -l next";
          "super + y" =
            "bspc node newest.marked.local -n newest.!automatic.local";
          "super + g" = "bspc node -s biggest";
          "super + {t,shift + t,f}" =
            "bspc node -t {tiled,pseudo_tiled,'~fullscreen'}";
          "super + shift + space" = "bspc node -t '~floating'";
          "super + ctrl + {m,x,y,z}" =
            "bspc node -g {marked,locked,sticky,private}";
          "super + {_,shift + }{h,j,k,l}" =
            "bspc node -{f,s} {west,south,north,east}";
          "super + {a,comma,period}" = "bspc node -f @{parent,first,second}";
          "super + {_,shift + }Tab" = "bspc node -f {next,prev}.local";
          "super + bracket{left,right}" = "bspc desktop -f {prev,next}.local";
          "super + {o,i}" = ''
              bspc wm -h off; \
            	bspc node {older,newer} -f; \
            	bspc wm -h on
          '';
          "super + ctrl + {h,j,k,l}" = "bspc node -p {west,south,north,east}";
          "super + ctrl + {1-9}" = "bspc node -o 0.{1-9}";
          "super + ctrl + space" = "bspc node -p cancel";
          "super + ctrl + shift + space" =
            "bspc query -N -d | xargs -I id -n 1 bspc node id -p cancel";
          "super + alt + {h,j,k,l}" =
            "bspc node -z {left -20 0,bottom 0 20,top 0 -20,right 20 0}";
          "super + alt + shift + {h,j,k,l}" =
            "bspc node -z {right -20 0,top 0 20,bottom 0 -20,left 20 0}";
          "super + {Left,Down,Up,Right}" =
            "bspc node -v {-20 0,0 20,0 -20,20 0}";
          "super + space ; t" = "tdrop -ma -w -5 -h 60% --wm bspwm  kitty";
          "super + Return" = "tdrop -ma -w -5 -h 60% --wm bspwm  kitty";
          "super + shift + Return" = "kitty";
          "super + F12" =
            "tdrop -ma -n rocket --wm bswpm -w -4 -y 0 -h 60% --pre-map-float-command 'bspc rule -a Chromium-browser -o state=floating' chromium --app=https://chat.semte.ch";
          "super + F11" =
            "tdrop -ma -n mmost --wm bswpm -w -4 -y 0 -h 60% --pre-map-float-command 'bspc rule -a Chromium-browser -o state=floating' chromium --app=https://mattermost.zeus.gent";
          "super + F10" =
            "tdrop -ma -n toggl --wm bswpm -w -4 -y 0 -h 60% --pre-map-float-command 'bspc rule -a Chromium-browser -o state=floating' chromium --app=https://track.toggl.com/timer";
          "super + F9" = "flameshot gui";
          "super + {grave}" =
            "tdrop -ma -n emacs --wm bswpm -w -4 -y 0 -h 60% --pre-map-float-command 'bspc rule -a Emacs -o state=floating' emacs";
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
          "super + n" = "thunar";
        };
      };
    };
  };
}
