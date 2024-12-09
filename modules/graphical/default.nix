{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.custom.graphical;
in
{
  imports = [
    ./wezterm.nix
    ./bspwm.nix
    ./wacom.nix
    ./polybar.nix
    ./kde.nix
    ./steam.nix
    ./fonts.nix
  ];
  options.custom.graphical = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    custom.wezterm.enable = true;
    custom.fonts.enable = true;

    services.displayManager = {
      sddm.enable = true;
    };
    services.xserver = {
      enable = true;
    };
    services.dbus = {
      enable = true;
    };
    programs.dconf.enable = true;
  };
}
