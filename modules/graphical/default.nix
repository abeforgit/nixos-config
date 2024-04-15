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
    custom.wezterm.enable = true;
    fonts = {
      enableDefaultPackages = true;
      fontconfig = { enable = true; };
      packages = with pkgs; [
        fira-go
        monaspace
        hack-font
        (nerdfonts.override {
          fonts = [
            "FiraCode"
            "DroidSansMono"
            "Hasklig"
            "NerdFontsSymbolsOnly"
            "Hack"
          ];
        })

      ];

    };

    services.displayManager = { sddm.enable = true; };
    services.xserver = {
      enable = true;
    };
    services.dbus = { enable = true; };
    programs.dconf.enable = true;
  };
}
