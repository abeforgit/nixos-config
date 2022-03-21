{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.polybar;
in {
  options.custom.polybar = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ fira-code nerdfonts ];
      services.polybar = {
        enable = true;
        package = pkgs.polybar.override {
          pulseSupport = true;
          mpdSupport = true;
        };
        script = ''

          killall -q polybar

          while pgrep -u $UID -x polybar >/dev/null; do sleep 1; done

          polybar -m | while read -r monitor; do

          	if  echo "$monitor" | grep "primary";  then
          		MONITOR=''${monitor//:*/} polybar primary &
          	else
          		MONITOR=''${monitor//:*/} polybar secondary &
          	fi
          done
                  '';
        settings = {
          colors = {
            background-alt = "\${xrdb:color4}";
            foreground = "\${xrdb:foreground}";
            foreground-alt = "\${xrdb:color3}";
            primary = "\${xrdb:color0}";
            secondary = "\${xrdb:color1}";
            alert = "\${xrdb:color2}";
            text = "\${xrdb:color1}";
            background = "\${xrdb:color0}";
            highlight = "\${xrdb:color2}";
            highlight-rim = "\${xrdb:color3}";
            accent = "\${xrdb:color4}";
            dull = "\${xrdb:color8}";
            color0 = "\${xrdb:color0}";
            color1 = "\${xrdb:color1}";
            color2 = "\${xrdb:color2}";
            color3 = "\${xrdb:color3}";
            color4 = "\${xrdb:color4}";
            color5 = "\${xrdb:color5}";
            color6 = "\${xrdb:color6}";
            color7 = "\${xrdb:color7}";
            color8 = "\${xrdb:color8}";
            color9 = "\${xrdb:color9}";
            color10 = "\${xrdb:color10}";
            color11 = "\${xrdb:color11}";
            color12 = "\${xrdb:color12}";
            color13 = "\${xrdb:color13}";
            color14 = "\${xrdb:color14}";
            color15 = "\${xrdb:color15}";
          };
          settings = { screenchange.reload = true; };
          "global/wm" = {
            margin = {
              top = 5;
              bottom = 5;
            };
          };

          "bar/primary" = {
            dpi = 192;
            monitor = "\${env:MONITOR}";
            bottom = true;
            height = 50;

            fixed-center = false;

            background = "\${colors.background}";
            foreground = "\${colors.foreground}";

            line-color = "#f00";

            border-bottom-size = 5;
            border-top-size = 5;
            border-top-color = "\${colors.color0}";
            border-bottom-color = "\${colors.color0}";

            module-margin-left = 1;
            module-margin-right = 2;

            font-0 = "Fura Code Nerd Font:style=Regular:size=14;8";
            font-1 = "Symbols Nerd Font:style=2048-em:size=28;8";
            font-2 = "Fura Code Nerd Font:style=Regular:size=16;8";

            modules-left = "xworkspaces";
            modules-right =
              "backlight pulseaudio filesystem memory cpu wlan temperature battery date";

            tray-position = "right";
            tray-maxsize = 50;
            tray-padding = "2%";

            wm-restack = "bspwm";

            scroll-up = "bspwm-desknext";
            scroll-down = "bspwm-deskprev";

            cursor-click = "pointer";
            cursor-scroll = "ns-resize";

          };
          "bar/secondary" = {
            "inherit" = "bar/primary";
            modules-right = "";
            tray-position = "none";
          };
          "module/bspwm" = { type = "internal/bspwm"; };
          "module/xworkspaces" = {
            type = "internal/xworkspaces";
            # icon-0 = code;♚
            # icon-1 = office;♛
            # icon-2 = graphics;♜
            # icon-3 = mail;♝
            # icon-4 = web;♞
            # icon-default = ♟

            format = "<label-state>";

            label = {

              monitor = "%name%";

              active = "%name%";
              active-foreground = "#ffffff";
              active-background = "#3f3f3f";
              active-underline = "#fba922";
              active-padding = 4;
            };

            # ; Available tokens:
            # ;   %name%
            # ;   %icon%
            # ;   %index%
            # ;   %nwin% (New in version 3.6.0)
            # ; Default: %icon% %name%
            label-occupied = "%name%";
            label-occupied-underline = "#555555";
            label-occupied-padding = 2;

            # ; Available tokens:
            # ;   %name%
            # ;   %icon%
            # ;   %index%
            # ;   %nwin% (New in version 3.6.0)
            # ; Default: %icon% %name%
            label-urgent = "%name%";
            label-urgent-foreground = "#000000";
            label-urgent-background = "#bd2c40";
            label-urgent-underline = "#9b0a20";
            label-urgent-padding = 4;

            # ; Available tokens:
            # ;   %name%
            # ;   %icon%
            # ;   %index%
            # ;   %nwin% (New in version 3.6.0)
            # ; Default: %icon% %name%
            label-empty = "%name%";
            label-empty-foreground = "#55";
            label-empty-padding = 2;
          };
          "module/backlight" = {
            type = "internal/backlight";
            card = "intel_backlight";
            enable-scroll = true;
          };
          "module/cpu" = {
            type = "internal/cpu";
            format.prefix = " ";
            label = "%percentage%";
          };
          "module/memory" = {
            type = "internal/memory";
            format.prefix = " ";
            label = "%percentage_used%";
          };
          "module/wlan" = {
            type = "internal/network";
            interface = "wlp82s0";
            ramp.signal = [ "" ];
          };
          "module/pulseaudio" = {
            type = "internal/pulseaudio";
            format = {
              volume = {
                text = "<label-volume>";
                prefix = "VOL ";
              };
            };
            label = {
              volume = "%percentage%";
              muted = "muted";
            };
            click.right = "pavucontrol";
          };
          "module/filesystem" = {
            type = "internal/fs";
            interval = 25;
            mount = [ "/" ];
          };
          "module/temperature" = {
            type = "internal/temperature";
            thermal.zone = 0;
            warn.temperature = 70;
          };
          "module/battery" = {
            type = "internal/battery";
            battery = "BAT0";
            adapter = "AC";
            full.at = 90;

          };
          "module/date" = {
            type = "internal/date";
            interval = 5;
            date.text = "";
            date.alt = " %Y-%m-%d";
            time.text = "%H:%M";
            time.alt = "%H:%M:%S";
            format.prefix.text = "";
            format.prefix.foreground = "\${colors.foreground-alt}";
            format.underline = "\${colors.color5}";
            label = "%date% %time%";
          };

        };
      };

    };

  };

}
