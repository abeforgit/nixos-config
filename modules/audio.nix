{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.audio;
in {
  options = {
    custom.audio.enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {
    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraConfig = "load-module module-switch-on-connect";
      extraModules = [ pkgs.pulseaudio-modules-bt ];
      package = pkgs.pulseaudioFull;
    };
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ pavucontrol ];
      services.mpris-proxy.enable = true;


    };

  };

}
