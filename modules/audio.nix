{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.audio;
in
{
  options = {
    custom.audio.enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio.enable = true;
    home-manager.users.${config.custom.user} = {pkgs, ...}: {
      home.packages = with pkgs; [
        pavucontrol
      ];

    };

  };

}
