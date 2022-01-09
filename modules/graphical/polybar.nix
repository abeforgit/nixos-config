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
        script = ''
          polybar bar1 &
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

          "bar/bar1" = {
            dpi = 192;
            # monitor = "\${"env:MONITOR"}";
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

            modules-left = "bspwm";
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
          "module/bspwm" = { type = "internal/bspwm"; };
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
            bar.volume = {
              width = 10;
              gradient = false;
              indicator = "|";
              fill = "-";
              empty = "-";

            };
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
