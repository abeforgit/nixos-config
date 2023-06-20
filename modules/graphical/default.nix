{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.graphical;
in {
  imports = [
    ./wezterm.nix
    ./bspwm.nix
    ./wacom.nix
    ./polybar.nix
    ./kde.nix
    ./steam.nix
  ];
  options.custom.graphical = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.bspwm.enable = false;
    custom.wezterm.enable = true;
    custom.kde.enable = true;
    custom.wacom.enable = false;
    custom.polybar.enable = false;

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wpgtk xorg.xev xorg.xkill kazam ];
    };

    services.dbus = { enable = true; };
    programs.dconf.enable = true;
  };
}
