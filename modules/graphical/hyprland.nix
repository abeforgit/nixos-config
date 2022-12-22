{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.hyprland;
in {
  options.custom.hyprland = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    programs.hyprland = {
      enable = true;
      xwayland = {
        enable = true;
        hidpi = true;
      };
      nvidiaPatches = true;

    };
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        fira-code
        pipewire
        wireplumber
        polkit-kde-agent
        dunst
        wlr-randr
        waybar

      ];
      wayland.windowManager.hyprland = {
        enable = true;
        nvidiaPatches = true;
      };
    };
  };

}
