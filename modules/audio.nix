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
    age.secrets.spotify = {
      file = ../secrets/spotify.age;
      owner = config.custom.user;
    };

    sound.enable = false;

    security.rtkit.enable = true;
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
    # hardware.pulseaudio = {
    #   enable = true;
    #   extraConfig = "load-module module-switch-on-connect";
    #   package = pkgs.pulseaudioFull;
    # };
    home-manager.users.${config.custom.user} = { pkgs, ... }: {

      home.packages = with pkgs; [
        pavucontrol
        spotify-tui
        spotify-unwrapped
      ];
      services.mpris-proxy.enable = true;
      programs.ncspot = {
        enable = true;
        package = pkgs.ncspot.override { withMPRIS = true; };
      };
      services.spotifyd = {
        enable = true;
        package = pkgs.spotifyd.override {
          withKeyring = true;
          withPulseAudio = true;
          withMpris = true;
        };
        settings = {
          global = {
            username = "arnebertrand@gmail.com";
            device_name = "finch";
            password_cmd =
              "${pkgs.coreutils}/bin/cat ${config.age.secrets.spotify.path}";
            bitrate = 320;
          };
        };
      };

    };

  };

}
