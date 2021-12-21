{ config, lib, pkgs, ... }:
let
  cfg = config.custom;
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in {
  imports = [
    ./bspwm.nix
    ./emacs.nix
    ./zsh.nix
    ./vscode.nix
    ./keychain.nix
    ./keyring.nix
    ./audio.nix
    ./nvim.nix
    ./git.nix
  ];

  options.custom = {
    user = lib.mkOption {
      example = "arne";
      default = "arne";
    };

    hostname = lib.mkOption { type = lib.types.str; };

    extraSystemPackages = lib.mkOption {
      default = [ ];
      example = [ pkgs.unzip ];
    };
    extraHomePackages = lib.mkOption {
      default = [ ];
      example = [ pkgs.spotify-tui ];
    };
  };

  config = {
    environment.systemPackages = with pkgs;
      [ neovim wget kitty nvidia-offload git git-lfs killall ntfs3g ]
      ++ cfg.extraSystemPackages;

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Brussels";
    users.users.${cfg.user} = {
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "wheel"
        "audio"
        "input"
        "video"
        "graphical"
        "vboxusers"
        "docker"
        "networkmanager"
      ];
    };
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
    };
    home-manager.users.${cfg.user} = { pkgs, home, ... }: {
      home.packages = with pkgs;
        [
          httpie
          firefox
          fira-code
          pciutils
          blueman
          tdrop
          docker-compose
          bat
          xfce.thunar
          xfce.thunar-volman
          xfce.thunar-archive-plugin
          xfce.thunar-media-tags-plugin
          arandr
        ] ++ cfg.extraHomePackages;

      xdg = {
        enable = true;
        userDirs = {
          desktop = "$HOME/desktop";
          documents = "$HOME/documents";
          download = "$HOME/downloads";
          music = "$HOME/music";
          pictures = "$HOME/pictures";
          publicShare = "$HOME/desktop";
          templates = "$HOME/templates";
          videos = "$HOME/videos";
        };
        mime.enable = true;
        configFile."mimeapps.list".force = true;
        mimeApps = {
          enable = true;
          defaultApplications = {
            "image/png" = [ "org.kde.okular.desktop" ];
            "image/jpg" = [ "org.kde.okular.desktop" ];
            "image/jpeg" = [ "org.kde.okular.desktop" ];
            "application/pdf" = [ "org.pwmt.zathura.desktop" ];

            "text/html" = [ "firefox.desktop" ];
            "x-scheme-handler/about" = [ "firefox.desktop" ];
            "x-scheme-handler/http" = [ "firefox.desktop" ];
            "x-scheme-handler/https" = [ "firefox.desktop" ];
            "x-scheme-handler/unknown" = [ "firefox.desktop" ];

            "x-scheme-handler/msteams" = [ "teams.desktop" ];
          };
        };
      };
      services.udiskie = {
        enable = true;
        automount = true;
        notify = true;
        tray = "auto";
      };
      programs.autorandr = {
        enable = true;
        profiles = {
          "home" = {
            fingerprint = {
              eDP1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI0 =
                "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
            };
            config = {
              eDP1 = {
                enable = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI0 = {
                enable = true;
                primary = true;
                position = "3840x0";
                mode = "3840x2160";
                rotate = "normal";
              };
            };
          };
          # workarounds for stupid monitor renaming issue
          "home-1" = {
            fingerprint = {
              eDP-1-1 =
                "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
              HDMI-0 =
                "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
            };
            config = {
              eDP-1-1 = {
                enable = true;
                position = "0x0";
                mode = "3840x2160";
                rotate = "normal";
              };
              HDMI-0 = {
                enable = true;
                primary = true;
                position = "3840x0";
                mode = "3840x2160";
                rotate = "normal";
              };
            };
          };
        };
      };
      programs.kitty = {
        enable = true;
        font.name = "Fira Code";
        font.size = 22;
        keybindings = {
          "kitty_mod+asterisk" = "change_font_size current +2.0";
          "kitty_mod+minus" = "change_font_size_current -2.0";
        };

        settings = {
          scrollback_lins = 10000;
          enable_audio_bell = false;
          background_opacity = "0.9";
          term = "xterm-kitty";
        };
      };
    };
  };

}
