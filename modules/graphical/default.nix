{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.graphical;
in {
  imports =
    [ ./wezterm.nix ./bspwm.nix ./wacom.nix ./polybar.nix ./herbstluftwm.nix ];
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
    custom.polybar.enable = false;

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wpgtk xorg.xev ];
    };

    services.dbus = { enable = true; };
    programs.dconf.enable = true;
  };
}
