{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.graphical;
in
{
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
    services.xserver = {
      enable = true;
      libinput = {
        enable = true;
        touchpad = {
          tapping = true;
          clickMethod = "clickfinger";
          accelProfile = "adaptive";
          accelSpeed = "2";
        };
      };
      desktopManager.session = [{
        name = "home-manager";
        start = ''
          ${pkgs.runtimeShell} $HOME/.hm-xsession &
          waitPID=$!
        '';
      }];
    };


  };

}
