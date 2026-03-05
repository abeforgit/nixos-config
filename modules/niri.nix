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

    environment.variables = {
      # GDK_SCALE = "2";
      # GDK_DPI_SCALE = "0.5";
      # _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
      # POLKIT_BIN = "${pkgs.kdePackages.polkit-kde-agent-1}/libexec/polkit-kde-authentication-agent-1";
      # GDK_BACKEND = "wayland,x11";
      # QT_QPA_PLATFORM = "wayland;xcb";
      # SDL_VIDEODRIVER = "wayland";
      # CLUTTER_BACKEND = "wayland";
      # QT_AUTO_SCREEN_SCALE_FACTOR = "1";
      # NIXOS_OZONE_WL = "1";
      # # WLR_NO_HARDWARE_CURSORS = "1";
    };
    environment.sessionVariables = {
      NIXOS_OZONE_WL = "1";
    };

    services.displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };

    programs.dms-shell = {
      enable = true;
      systemd = {
        enable = true; # Systemd service for auto-start
        restartIfChanged = true; # Auto-restart dms.service when dms-shell changes
      };

      # Core features
      enableSystemMonitoring = true; # System monitoring widgets (dgop)
      enableVPN = true; # VPN management widget
      enableDynamicTheming = true; # Wallpaper-based theming (matugen)
      enableAudioWavelength = true; # Audio visualizer (cava)
      enableCalendarEvents = true; # Calendar integration (khal)
      enableClipboardPaste = true; # Pasting from the clipboard history (wtype)
    };
    home-manager.users.${config.custom.user} =
      { pkgs, home, ... }:
      {
        # programs.swaylock.enable = true; # Super+Alt+L in the default setting (screen locker)
        # programs.waybar.enable = true; # launch on startup in the default setting (bar)
        # services.mako.enable = true; # notification daemon
        # services.swayidle = {
        #   enable = true;
        #   events = {
        #     before-sleep = "${pkgs.swaylock}/bin/swaylock -fF";
        #     lock = "lock";
        #   };
        #   timeouts = [
        #     {
        #       timeout = 300;
        #       command = "${pkgs.swaylock}/bin/swaylock -fF";
        #     }
        #     {
        #       timeout = 1800;
        #       command = "${pkgs.systemd}/bin/systemctl suspend";
        #     }
        #   ];
        #
        # };

        services.polkit-gnome.enable = true; # polkit
        home.packages = with pkgs; [
          swaybg # wallpaper
        ];
      };
  };

}
