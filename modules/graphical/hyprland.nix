{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.hyprland;
in {
  options.custom.hyprland = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
        hidpi = true;
      };
      nvidiaPatches = true;

    };
    home-manager.users.${config.custom.user} = { pkgs, ... }:
      let
        launcher = pkgs.wofi;
        terminal = pkgs.wezterm;
        colors = rec {
          rosewater = "f5e0dc";
          flamingo = "f2cdcd";
          pink = "f5c2e7";
          mauve = "cba6f7";
          red = "f38ba8";
          maroon = "eba0ac";
          peach = "fab387";
          yellow = "f9e2af";
          green = "a6e3a1";
          teal = "94e2d5";
          sky = "89dceb";
          sapphire = "74c7ec";
          blue = "89b4fa";
          lavender = "b4befe";

          text = "cdd6f4";
          subtext1 = "bac2de";
          subtext0 = "a6adc8";
          overlay2 = "9399b2";
          overlay1 = "7f849c";
          overlay0 = "6c7086";

          surface2 = "585b70";
          surface1 = "45475a";
          surface0 = "313244";

          base = "1e1e2e";
          mantle = "181825";
          crust = "11111b";

          fg = text;
          bg = base;
          bg1 = surface0;
          border = "28283d";
          shadow = crust;
        };

      in {
        home.packages = with pkgs; [
          fira-code
          pipewire
          wireplumber
          polkit-kde-agent
          dunst
          wlr-randr
          eww
          wofi
          wlogout
          grim
          slurp
          xorg.xprop
          wezterm

        ];
        home.sessionVariables = {
          # upscale steam
          GDK_SCALE = "2";
          _JAVA_AWT_WM_NONREPARENTING = "1";
          MOZ_ENABLE_WAYLAND = "1";
          QT_QPA_PLATFORM = "wayland";
          QT_WAYLAND_DISABLE_WINDOWDECORATION = "1";
          SDL_VIDEODRIVER = "wayland";
          XDG_SESSION_TYPE = "wayland";
          WLR_NO_HARDWARE_CURSORS = "1";
        };

        # screen idle
        services.swayidle = {
          enable = false;
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
            }
            {
              event = "lock";
              command = "${pkgs.swaylock-effects}/bin/swaylock -fF";
            }
          ];
          timeouts = [
            {
              timeout = 300;
              command =
                "${pkgs.hyprland}/bin/hyprctl dispatch dpms off";
              resumeCommand =
                "${pkgs.hyprland}/bin/hyprctl dispatch dpms on";
            }
            {
              timeout = 310;
              command = "${pkgs.systemd}/bin/loginctl lock-session";
            }
          ];
        };
        # systemd.user.services.swayidle.Install.WantedBy =
         #  lib.mkForce [ "hyprland-session.target" ];
        wayland.windowManager.hyprland = {
          enable = true;
          nvidiaPatches = true;
          extraConfig = ''
              $mod = SUPER
              monitor = eDP-1, preferred, auto, auto
              monitor = HDMI-A-1, preferred, auto, 2
              workspace = eDP-1, 1
              workspace = HDMI-A-1, 1
              exec-once = xprop -root -f _XWAYLAND_GLOBAL_OUTPUT_SCALE 32c -set _XWAYLAND_GLOBAL_OUTPUT_SCALE 2
              exec-once = wezterm
              # exec-once = eww open bar
              misc {
                # enable Variable Frame Rate
                no_vfr = 0
                # disable auto polling for config file changes
                disable_autoreload = 0
              }
              general {
                gaps_in = 5
                gaps_out = 5
                border_size = 2
                col.active_border = rgb(${colors.blue}) rgb(${colors.mauve}) 270deg
                col.inactive_border = rgb(${colors.crust}) rgb(${colors.lavender}) 270deg
              }
              decoration {
                  rounding = 16
                  blur = 1
                  blur_size = 3
                  blur_passes = 3
                  blur_new_optimizations = 1
                  drop_shadow = 1
                  shadow_ignore_window = 1
                  shadow_offset = 2 2
                  shadow_range = 4
                  shadow_render_power = 1
                  col.shadow = 0x55000000
                }
                animations {
                  enabled = 1
                  animation = border, 1, 2, default
                  animation = fade, 1, 4, default
                  animation = windows, 1, 3, default, popin 80%
                  animation = workspaces, 1, 2, default, slide
                }
                dwindle {
                  # keep floating dimentions while tiling
                  pseudotile = 1
                  preserve_split = 1
                  # group borders
                  col.group_border_active = rgb(${colors.pink})
                  col.group_border = rgb(${colors.surface0})
                }
            # mouse movements
                bindm = $mod, mouse:272, movewindow
                bindm = $mod, mouse:273, resizewindow
                bindm = $mod ALT, mouse:272, resizewindow
                # compositor commands
                bind = $mod SHIFT, E, exec, pkill Hyprland
                bind = $mod SHIFT, Q, killactive,
                bind = $mod, F, fullscreen,
                bind = $mod, G, togglegroup,
                bind = $mod SHIFT, N, changegroupactive, f
                bind = $mod SHIFT, P, changegroupactive, b
                bind = $mod, R, togglesplit,
                bind = $mod SHIFT, F, togglefloating,
                bind = $mod, P, pseudo,
                bind = $mod ALT, ,resizeactive,
                # toggle "monocle" (no_gaps_when_only)
                $kw = dwindle:no_gaps_when_only
                bind = $mod, M, exec, hyprctl keyword $kw $(($(hyprctl getoption $kw -j | jaq -r '.int') ^ 1))
                # utility
                # launcher
                bindr = $mod, SUPER_L, exec, pkill wofi || wofi --show run
                # terminal
                bind = $mod, Return, exec, wezterm
                # logout menu
                bind = $mod, Escape, exec, wlogout -p layer-shell
                # lock screen
                bind = $mod, L, exec, loginctl lock-session
                # move focus
                bind = $mod, h , movefocus, l
                bind = $mod, l , movefocus, r
                bind = $mod, k , movefocus, u
                bind = $mod, j , movefocus, d
                # window resize
                bind = $mod, S, submap, resize
                submap = resize
                binde = , right, resizeactive, 10 0
                binde = , left, resizeactive, -10 0
                binde = , up, resizeactive, 0 -10
                binde = , down, resizeactive, 0 10
                bind = , escape, submap, reset
                submap = reset
                # media controls
                bindl = , XF86AudioPlay, exec, playerctl play-pause
                bindl = , XF86AudioPrev, exec, playerctl previous
                bindl = , XF86AudioNext, exec, playerctl next
                # volume
                bindle = , XF86AudioRaiseVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%+
                bindle = , XF86AudioLowerVolume, exec, wpctl set-volume @DEFAULT_AUDIO_SINK@ 6%-
                bindl = , XF86AudioMute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle
                bindl = , XF86AudioMicMute, exec, wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle
                # backlight
                bindle = , XF86MonBrightnessUp, exec, light -A 5
                bindle = , XF86MonBrightnessDown, exec, light -U 5
                # screenshot
                # stop animations while screenshotting; makes black border go away
                $screenshotarea = hyprctl keyword animation "fadeOut,0,0,default"; grimblast --notify copysave area; hyprctl keyword animation "fadeOut,1,4,default"
                bind = , Print, exec, $screenshotarea
                bind = $mod SHIFT, R, exec, $screenshotarea
                bind = CTRL, Print, exec, grimblast --notify --cursor copysave output
                bind = $mod SHIFT CTRL, R, exec, grimblast --notify --cursor copysave output
                bind = ALT, Print, exec, grimblast --notify --cursor copysave screen
                bind = $mod SHIFT ALT, R, exec, grimblast --notify --cursor copysave screen
                # workspaces
                # binds mod + [shift +] {1..10} to [move to] ws {1..10}
                ${
                  builtins.concatStringsSep "\n" (builtins.genList (x:
                    let
                      ws = let c = (x + 1) / 10;
                      in builtins.toString (x + 1 - (c * 10));
                    in ''
                      bind = $mod, ${ws}, workspace, ${toString (x + 1)}
                      bind = $mod SHIFT, ${ws}, movetoworkspace, ${
                        toString (x + 1)
                      }
                    '') 10)
                }
                # special workspace
                bind = $mod SHIFT, grave, movetoworkspace, special
                bind = $mod, grave, togglespecialworkspace, eDP-1
                # cycle workspaces
                bind = $mod, bracketleft, workspace, m-1
                bind = $mod, bracketright, workspace, m+1
                # cycle monitors
                bind = $mod SHIFT, braceleft, focusmonitor, l
                bind = $mod SHIFT, braceright, focusmonitor, r
          '';

        };
      };
  };

}
