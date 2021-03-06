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

    sound.enable = true;
    hardware.pulseaudio = {
      enable = true;
      extraConfig = "load-module module-switch-on-connect";
      package = pkgs.pulseaudioFull;
    };
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [
        # spotify
        pavucontrol
        spotify-tui
        # spicetify-cli
        (spotify-spicetified.override {
          theme = "ddt";
          injectCss = true;
          replaceColors = true;
          overwriteAssets = true;
          customThemes = { "ddt" = "${pkgs.dribbblish-dynamic-theme}/theme"; };
          customExtensions = {
            "ddt.js" =
              "${pkgs.dribbblish-dynamic-theme}/extensions/dribbblish-dynamic.js";
          };
          enabledCustomApps = [ "lyrics-plus" "new-releases" "reddit" ];
          enabledExtensions = [
            "ddt.js"
            "fullAppDisplay.js"
            "loopyLoop.js"
            "popupLyrics.js"
            "shuffle+.js"
            "trashbin.js"
            "keyboardShortcut.js"
          ];
          extraConfig = ''
            [Patch]
            xpui.js_find_8008 = ,(\w+=)32,
            xpui.js_repl_8008 = ,''${1}58,
          '';
        })
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
