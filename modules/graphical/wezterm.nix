{ pkgs, config, lib, activitywatch, ... }:
with lib;
let cfg = config.custom.wezterm;
in {
  options.custom.wezterm = {
    enable = mkOption {
      example = true;
      default = false;

    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ wezterm ];
      # xdg.configFile.weztermConfig = {
      #   source = ./wezterm/wezterm.lua;
      #   target = "wezterm/wezterm.lua";


      # };
    };
  };
}
