{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.graphical;
in {
  imports = [ ./bspwm.nix ./wacom.nix ./polybar.nix ];
  options.custom.graphical = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.bspwm.enable = true;
    custom.wacom.enable = true;
    custom.polybar.enable = true;

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wpgtk ];
    };
    services.picom = {
      enable = true;
      experimentalBackends = true;
      backend = "xrender";
    };
    services.dbus = { enable = true; };
    services.xserver = {
      enable = true;
      synaptics = {
        enable = true;
        vertTwoFingerScroll = true;
        horizTwoFingerScroll = true;
        buttonsMap = [ 1 3 2 ];
        maxSpeed = "10";
        minSpeed = "10";
      };
      displayManager = {
        lightdm = {
          enable = true;
        };

        session = [{
          name = "bspwm";
          manage = "window";
          start = ''
            ${pkgs.runtimeShell} $HOME/.hm-xsession &
            waitPID=$!
          '';
        }];
      };
    };

  };

}
