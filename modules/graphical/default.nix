{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.graphical;
in {
  imports = [ ./wezterm.nix ./bspwm.nix ./wacom.nix ./polybar.nix ./herbstluftwm.nix ];
  options.custom.graphical = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.bspwm.enable = false;
    custom.wezterm.enable = true;
    custom.herbstluft.enable = true;
    custom.wacom.enable = false;
    custom.polybar.enable = true;

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wpgtk xorg.xev ];

      programs.autorandr = {
        enable = true;
        profiles = {
          "single" = {
            fingerprint = {
              eDP1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI0 =
                "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
            };
            config = {
              eDP1 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI0 = { enable = false; };
            };
            hooks.postswitch = readFile ./reload-wm.sh;
          };
          "single-1" = {
            fingerprint = {
              eDP-1-1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI-0 =
                "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
            };
            config = {
              eDP-1-1 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI-0 = { enable = false; };
            };
            hooks.postswitch = readFile ./reload-wm.sh;
          };
          "home" = {
            fingerprint = {
              eDP1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI0 =
                "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
            };
            config = {
              eDP1 = {
                enable = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI0 = {
                enable = true;
                primary = true;
                position = "3840x0";
                mode = "3840x2160";
                rotate = "normal";
              };
            };
            hooks.postswitch = readFile ./reload-wm.sh;
          };
          # workarounds for stupid monitor renaming issue
          "home-1" = {
            fingerprint = {
              eDP-1-1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI-0 =
                "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
            };
            config = {
              eDP-1-1 = {
                enable = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI-0 = {
                enable = true;
                primary = true;
                position = "3840x0";
                mode = "3840x2160";
                rotate = "normal";
              };
            };
            hooks.postswitch = readFile ./reload-wm.sh;
          };

          "work" = {
            fingerprint = {
              eDP-1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI-0 =
                "00ffffffffffff0010acdad0425457342c1d010380351e78ea0565a756529c270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00364852323259320a2020202020000000fc0044454c4c205032343139480a20000000fd00384c1e5311000a20202020202001ed020317b14c9005040302071601141f121365030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000000000000000000000000003d";
            };
            config = {
              eDP-1 = {
                enable = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI-0 = {
                enable = true;
                primary = true;
                position = "3840x0";
                mode = "1920x1080";
                rotate = "normal";
              };
            };
            hooks.postswitch = readFile ./reload-wm.sh;
          };
          "work-1" = {
            fingerprint = {
              eDP-1-1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI-0 =
                "00ffffffffffff0010acdad0425457342c1d010380351e78ea0565a756529c270f5054a54b00714f8180a9c0d1c00101010101010101023a801871382d40582c45000f282100001e000000ff00364852323259320a2020202020000000fc0044454c4c205032343139480a20000000fd00384c1e5311000a20202020202001ed020317b14c9005040302071601141f121365030c001000023a801871382d40582c45000f282100001e011d8018711c1620582c25000f282100009e011d007251d01e206e2855000f282100001e8c0ad08a20e02d10103e96000f282100001800000000000000000000000000000000000000000000000000000000000000003d";
            };
            config = {
              eDP-1-1 = {
                enable = true;
                primary = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI-0 = {
                enable = true;
                position = "3854x0";
                mode = "1920x1080";
              };
            };
            hooks.postswitch = readFile ./reload-wm.sh;
          };
        };
      };
    };
    services.picom = {
      enable = true;
      experimentalBackends = true;
      backend = "xrender";
    };
    services.dbus = { enable = true; };
    programs.dconf.enable = true;
    services.xserver = {
      enable = true;
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          scrollMethod = "twofinger";
          horizontalScrolling = true;
          disableWhileTyping = true;
          accelProfile = "adaptive";
          accelSpeed = "0";
          #          additionalOptions = ''
          #            Option "DPIScaleFactor" 2.0
          #            '';
        };

      };
      synaptics = {
        enable = false;
        vertTwoFingerScroll = true;
        horizTwoFingerScroll = true;
        buttonsMap = [ 1 3 2 ];
        maxSpeed = "2.0";
        # minSpeed = "1";
        accelFactor = "0.08";
        tapButtons = false;
        palmDetect = true;
        palmMinWidth = 8;
        palmMinZ = 100;
        additionalOptions = ''
          Option "FingerHigh" "50"
          Option "ClickTime" "50"
        '';

      };
      displayManager = {
        lightdm = { enable = true; };

        # session = [{
        #   name = "bspwm";
        #   manage = "window";
        #   start = ''
        #     ${pkgs.runtimeShell} $HOME/.hm-xsession &
        #     waitPID=$!
        #   '';
        # }];
      };
    };
  };
}
