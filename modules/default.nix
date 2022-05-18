{ config, lib, pkgs, agenix-cli, ... }:
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
    ./graphical
    ./emacs.nix
    ./zsh.nix
    ./vscode.nix
    ./keychain.nix
    ./keyring.nix
    ./audio.nix
    ./nvim.nix
    ./git.nix
    ./intellij.nix
    ./rider.nix
    ./webstorm.nix
    ./rustup.nix
    ./tmux.nix
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
      [
        neovim
        wget
        kitty
        nvidia-offload
        git
        git-lfs
        killall
        ntfs3g
        file
        nix-index
        zip
        unzip
        agenix-cli
        wally-cli
        fup-repl
      ] ++ cfg.extraSystemPackages;

    i18n.defaultLocale = "en_US.UTF-8";
    time.timeZone = "Europe/Brussels";
    users.groups.${cfg.user} = { gid = 1000; };
    users.groups.plugdev = { };
    users.users.${cfg.user} = {
      group = cfg.user;
      uid = 1000;
      subUidRanges = [{
        count = 65534;
        startUid = 1000;
      }];
      subGidRanges = [{
        count = 65534;
        startGid = 1000;
      }];
      isNormalUser = true;
      createHome = true;
      extraGroups = [
        "users"
        "wheel"
        "audio"
        "input"
        "video"
        "graphical"
        "vboxusers"
        "docker"
        "networkmanager"
        "lp"
        "plugdev"
      ];
    };
    nix = {
      package = pkgs.nixFlakes;
      extraOptions = ''
        experimental-features = nix-command flakes
      '';
      gc = {
        automatic = true;
        dates = "daily";
        options = "--delete-older-than 7d";
      };
      optimise = {
        automatic = true;
        dates = [ "daily" ];
      };
    };
    services.openssh = {
      enable = true;
      passwordAuthentication = false;
      permitRootLogin = "prohibit-password";
      hostKeys = [
        {
          bits = 4096;
          path = "/etc/ssh/ssh_host_rsa_key";
          type = "rsa";
        }
        {
          path = "/etc/ssh/ssh_host_ed25519_key";
          type = "ed25519";
        }
      ];
      authorizedKeysFiles = [ "/run/agenix/authorized_keys/%u" ];
    };
    age.secrets."authorized_keys/root".file =
      ../secrets/authorized_keys/root.age;
    age.secrets."authorized_keys/arne" = {
      file = ../secrets/authorized_keys/arne.age;
      owner = "arne";
    };
    home-manager.users.${cfg.user} = { pkgs, home, ... }: {
      home.packages = with pkgs;
        [
          httpie
          chromium
          fira-code
          pciutils
          docker-compose
          bat
          xfce.thunar
          xfce.thunar-volman
          xfce.thunar-archive-plugin
          xfce.thunar-media-tags-plugin
          arandr
        ] ++ cfg.extraHomePackages;
      programs.firefox = {
        enable = true;
        profiles.${cfg.user} = {
          userChrome = ''
                        /* Hide tab bar in FF Quantum */
            #main-window[tabsintitlebar="true"]:not([extradragspace="true"]) #TabsToolbar > .toolbar-items {
              opacity: 0;
              pointer-events: none;
            }
            #main-window:not([tabsintitlebar="true"]) #TabsToolbar {
                visibility: collapse !important;
            }
          '';

        };
      };

      home.sessionPath = [ "$HOME/.local/bin" ];
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
