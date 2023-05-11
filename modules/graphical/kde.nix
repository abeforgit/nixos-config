{ pkgs, config, lib, activitywatch, ... }:
with lib;
let cfg = config.custom.kde;
in {
  imports = [ ./polybar.nix ];
  options.custom.kde = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services.xserver = {
      enable = true;
      displayManager = {
        sddm.enable = true;
      };
      desktopManager = {
        plasma5 = {
          enable = true;
          runUsingSystemd = false;
        };
      };
    };
    services.dbus = { enable = true; };
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        fira-code
        tdrop
        wmname
        vlc
        xorg.xwininfo
        xdotool
        acpilight
        ant-theme
        picom
        plano-theme
        juno-theme
        qogir-theme
        qogir-icon-theme
        glxinfo
        vulkan-tools
        obsidian
        xorg.xdpyinfo
        pkgs.libsForQt5.qtdbusextended
        pkgs.libsForQt5.plasma-browser-integration
        pkgs.libsForQt5.kontact
        pkgs.libsForQt5.kmail
        pkgs.libsForQt5.kaccounts-providers
        pkgs.libsForQt5.kaccounts-integration
        pkgs.libsForQt5.korganizer
        pkgs.libsForQt5.kalendar
        pkgs.libsForQt5.kcharselect
        pkgs.libsForQt5.rocs
        ktimetracker
        soulseekqt
        peek
        obs-studio

        pkgs.libsForQt5.kaddressbook
        pkgs.libsForQt5.akregator
        pkgs.libsForQt5.knotes

      ];

      programs.rofi = {
        enable = true;
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
      services.fusuma = {
        enable = true;
        extraPackages = with pkgs; [
          coreutils
          xdotool
          pkgs.libsForQt5.qtdbusextended
          pkgs.libsForQt5.qt5.qttools
        ];
        settings = {
          threshold = { swipe = 0.1; };
          interval = { swipe = 0.7; };
          swipe = {
            "3" = {
              left = {
                command = ''
                  ${pkgs.libsForQt5.qt5.qttools.bin}/bin/qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Switch to Next Desktop"
                '';
              };
              right = {
                command = ''
                  ${pkgs.libsForQt5.qt5.qttools.bin}/bin/qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Switch to Previous Desktop"
                '';
              };
              up = {
                command = ''
                  ${pkgs.libsForQt5.qt5.qttools.bin}/bin/qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "Overview"
                '';
              };
              down = {
                command = ''
                  ${pkgs.libsForQt5.qt5.qttools.bin}/bin/qdbus org.kde.kglobalaccel /component/kwin org.kde.kglobalaccel.Component.invokeShortcut "ExposeAll"
                '';
              };
            };
          };

        };

      };
      services.flameshot = { enable = true; };

      # home.file."reload-wm" = {
      #   source = ./reload-wm.sh;
      #   executable = true;
      #   target = ".local/bin/reload-wm";
      # };
      home.file."swap-window" = {
        source = ./swap-window.sh;
        executable = true;
        target = ".local/bin/swap-window";
      };
      services.sxhkd = {
        enable = false;
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
          # "XF86AudioRaiseVolume" = "pactl set-sink-volume 0 +5%";
          # "XF86AudioLowerVolume" = "pactl set-sink-volume 0 -5%";
          # "XF86AudioMute" = "pactl set-sink-mute 0 toggle";
          # "XF86AudioPlay" = "playerctl play";
          # "XF86AudioPause" = "playerctl pause";
          # "XF86AudioNext" = "playerctl next";
          # "XF86AudioPrev" = "playerctl previous";
          "Print" = "flameshot gui";
          # "super + o; f" = "thunar";
        };
      };
    };
  };
}
