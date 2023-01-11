{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.graphical;
in {
  imports = [
    ./wezterm.nix
    ./bspwm.nix
    ./wacom.nix
    ./polybar.nix
    ./herbstluftwm.nix
    ./steam.nix
    ./hyprland.nix
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
    custom.herbstluft.enable = true;
    custom.hyprland.enable = false;
    custom.wacom.enable = false;
    custom.polybar.enable = false;
    stylix = {
      fonts = {
        monospace = {
          package = pkgs.fira-code;
          name = "Fira Code";
        };
      };

      image = ./totoro.jpg;
    };

    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wpgtk xorg.xev ];
    };

    services.dbus = { enable = true; };
    programs.dconf.enable = true;
  };
}
