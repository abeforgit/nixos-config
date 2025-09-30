{
  config,
  lib,
  pkgs,
  ...
}:

with lib;

let
  cfg = config.custom.niri;
in
{
  options = {
    custom.niri.enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {
    programs.niri.enable = true;
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      nautilus
    ];

    services.displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };

    home-manager.users.${config.custom.user} =
      { pkgs, home, ... }:
      {
        programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
        programs.waybar.enable = true; # launch on startup in the default setting (bar)
        services.mako.enable = true; # notification daemon
        services.swayidle = {
          enable = true;
          events = [
            {
              event = "before-sleep";
              command = "${pkgs.swaylock}/bin/swaylock -fF";
            }
            {
              event = "lock";
              command = "lock";
            }

          ];
          timeouts = [
            {
              timeout = 300;
              command = "${pkgs.swaylock}/bin/swaylock -fF";
            }
            {
              timeout = 1800;
              command = "${pkgs.systemd}/bin/systemctl suspend";
            }
          ];

        };
        services.polkit-gnome.enable = true; # polkit
        home.packages = with pkgs; [
          swaybg # wallpaper
        ];
      };
  };

}
