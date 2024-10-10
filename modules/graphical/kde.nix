{
  pkgs,
  config,
  lib,
  ...
}:
with lib;
let
  cfg = config.custom.kde;
in
{
  # imports = [ ./polybar.nix ];
  options.custom.kde = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    services.displayManager = {
      sddm.enable = true;
      sddm.wayland.enable = true;
    };
    services.desktopManager = {
      plasma6 = {
        enable = true;
      };
    };
    services.dbus = {
      enable = true;
    };
    home-manager.users.${config.custom.user} =
      { pkgs, ... }:
      {
        home.packages = with pkgs; [
          fira-code
          wmname
          vlc
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
          pkgs.libsForQt5.kaccounts-providers
          pkgs.libsForQt5.kaccounts-integration
          pkgs.libsForQt5.kcharselect
          smbmap
          smbscan
          samba
          libsForQt5.kdenetwork-filesharing
          packagekit

          ffmpeg_6

        ];
        programs.obs-studio = {
          enable = true;
          plugins = with pkgs.obs-studio-plugins; [
            input-overlay
            wlrobs

          ];
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
            threshold = {
              swipe = 0.1;
            };
            interval = {
              swipe = 0.7;
            };
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
      };
  };
}
