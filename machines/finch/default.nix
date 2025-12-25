# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{
  config,
  pkgs,
  lib,
  ...
}:

let
  username = "arne";

  brightness_udev = pkgs.writeTextFile {
    name = "brightness_udev";
    text = ''
      SUBSYSTEM=="backlight", ACTION=="add", \
        RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/backlight/%k/brightness", \
        RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/backlight/%k/brightness"
      SUBSYSTEM=="leds", ACTION=="add", KERNEL=="*::kbd_backlight", \
        RUN+="${pkgs.coreutils}/bin/chgrp video /sys/class/leds/%k/brightness", \
        RUN+="${pkgs.coreutils}/bin/chmod g+w /sys/class/leds/%k/brightness"
    '';
    destination = "/etc/udev/rules.d/90-backlight.rules";
  };
  oryx_udev = pkgs.writeTextFile {
    name = "oryx_udev";
    text = ''
      KERNEL=="hidraw*", ATTRS{idVendor}=="16c0", MODE="0664", GROUP="plugdev"
      KERNEL=="hidraw*", ATTRS{idVendor}=="3297", MODE="0664", GROUP="plugdev"

      # Legacy rules for live training over webusb (Not needed for firmware v21+)
        # Rule for all ZSA keyboards
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", GROUP="plugdev"
      # Rule for the Moonlander
      SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
      # Keymapp / Wally Flashing rules for the Moonlander and Planck EZ
      SUBSYSTEMS=="usb", ATTRS{idVendor}=="0483", ATTRS{idProduct}=="df11", MODE:="0666", SYMLINK+="stm32_dfu"
    '';
    destination = "/etc/udev/rules.d/50-zsa.rules";
  };
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.extraModprobeConfig = ''
    options hid_apple swap_opt_cmd=1
    options hid_apple swap_fn_leftctrl=1
    options hid_apple fnmode=2
  '';
  boot.supportedFilesystems = [ "ntfs" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;
  boot.loader.grub.default = "saved";
  boot.loader.grub.fontSize = 32;
  boot.loader.grub.font = pkgs.hack-font;
  # make appimages work ootb
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    magicOrExtension = "\\x7fELF....AI\\x02";
  };

  networking.hostName = "finch"; # Define your hostname.
  #     127.0.0.1 register.reglementairebijlage.vlaanderen.be
  #     127.0.0.1 register.reglementairebijlagen.vlaanderen.be
  #      127.0.0.1 gelinkt-notuleren.lblod.info
  networking.extraHosts = ''
    127.0.0.1 gn.localhost
    127.0.0.2 publication.localhost
  '';
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp82s0.useDHCP = true;
  # the npm registry is not reachable with ipv6 for some reason
  networking.enableIPv6 = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #  font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  nix.settings = {
    substituters = [
      "https://nix-community.cachix.org"
      "https://cache.nixos.org"
      "https://cachix.cachix.org"
    ];
    trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cachix.cachix.org-1:eWNHQldwUO7G2VkjpnjDbWwy4KQ/HNxht7H4SSoMckM="
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];

  };
  nix.package = pkgs.nixVersions.latest;
  i18n.defaultLocale = "en_US.UTF-8";
  i18n.extraLocaleSettings = {
    LC_ALL = "en_US.UTF-8";
    LANGUAGE = "en_US.UTF-8";
    LC_MONETARY = "nl_BE.UTF-8";
    LC_MEASUREMENT = "nl_BE.UTF-8";
    LC_TIME = "en_GB.UTF-8";
    LC_NUMERIC = "nl_BE.UTF-8";
    LANG = "en_US.UTF-8";
  };
  # Enable the X11 windowing system.

  nixpkgs.config = {
    permittedInsecurePackages = [ "electron-27.3.11" ];
  };

  services.udev.packages = [
    brightness_udev
    oryx_udev
  ];
  services.thermald.enable = true;
  services.thinkfan = {
    enable = true;

  };
  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };

  services.gvfs.enable = true;
  environment.variables = {
    # GDK_SCALE = "2";
    # GDK_DPI_SCALE = "0.5";
    # _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
  };

  home-manager.users.arne =
    { pkgs, home, ... }:
    {
      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
        size = 24;
      };

      xdg = {
        mimeApps = {
          enable = true;
          defaultApplications = {
            "x-scheme-handler/spotify" = [ "spotify.desktop" ];
          };
        };

      };
      services.mpris-proxy.enable = true;
      programs.zsh.profileExtra = ''
        source ${config.age.secrets.github_auth.path}
        source ${config.age.secrets.jira_pat.path}
      '';
      qt = {
        enable = true;
        platformTheme = {
          name = "qt5ct";
        };
      };
      gtk = {
        enable = true;
        theme = {
          package = pkgs.flat-remix-gtk;
          name = "Flat-Remix-GTK-Grey-Darkest";
        };
        cursorTheme = {
          package = pkgs.nordzy-cursor-theme;
          name = "Nordzy-cursors";
          size = 24;
        };

        iconTheme = {
          package = pkgs.flat-remix-icon-theme;
          name = "Flat-Remix-Blue-Dark";
        };

        font = {
          name = "Sans";
          size = 11;
        };
      };
    };
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
  };
  services.xserver = {
    videoDrivers = [ "nvidia" ];
    dpi = 192;
    xkb = {
      options = "eurosign:e";
      layout = "us";
    };
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "o
    '';
  };

  services.postgresql = {
    enable = true;
  };
  boot.kernelParams = [ "i915.enable_dcpcd_backlight=1" ];
  hardware.nvidia = {
    open = false;
    nvidiaSettings = true;
    modesetting.enable = true;
    powerManagement.finegrained = true;
    prime = {
      reverseSync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  programs.hyprland = {
    # portalPackage = pkgs.xdg-desktop-portal-wlr;
    enable = true;
  };
  programs.hyprlock.enable = true;
  services.hypridle.enable = true;
  age.secrets = {
    github_auth = {
      file = ../../secrets/github_auth.age;
      owner = config.custom.user;
    };
    jira_pat = {
      file = ../../secrets/jira_pat.age;
      owner = config.custom.user;
    };
  };

  programs.nix-ld.enable = true;
  custom.user = username;
  custom.graphical.enable = true;
  custom.kde.enable = false;
  custom.emacs.enable = true;
  custom.emacs.package = pkgs.emacs30;
  custom.zsh.enable = true;
  custom.vscode.enable = true;
  custom.keychain.enable = true;
  custom.keyring.enable = false;
  custom.audio.enable = true;
  custom.nvim.enable = true;
  custom.git.enable = true;
  custom.rustup.enable = false;
  custom.hostname = "finch";
  custom.extraHomePackages = with pkgs; [
    thunderbird
    discord
    btop
    cachix
    # cudatoolkit
    filezilla
    idasen
    # calibre
    # godot-mono
    lorien
    nvd
    signal-desktop
    powertop
    anki-bin
    usbutils
    bitwarden-desktop
    obsidian
    # nix-sweep
    lazygit
    tofi
    hyprpaper
    rbw
    rofi-rbw
    pinentry-curses
    dig.dnsutils
    kdePackages.polkit-kde-agent-1
    kdePackages.qtwayland
    qt6.qtwayland
    qt6Packages.qt6ct
    dnstop
    dnstracer
    dnsperf
    nwg-look
    udiskie
    waybar
    pinta
    lazydocker
    galaxy-buds-client
    activitywatch
    aw-server-rust
    networkmanagerapplet
    grim
    slurp
    satty
    copyq
  ];

  custom.extraSystemPackages = with pkgs; [
    sqlite
    udiskie
    ntfs3g
    monaspace
    fira-code
    (giph.override { ffmpeg = ffmpeg-full; })
    vokoscreen-ng
    simplescreenrecorder
    copyq
    nvtopPackages.full
    wl-clipboard
    kdePackages.xdg-desktop-portal-kde
    kdePackages.filelight
  ];
  users.users.arne = {
    shell = pkgs.zsh;
  };
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  systemd.settings.Manager = {
    DefaultTimeoutStopSec = "10s";
  };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      "default-ulimits" = {
        "nofile" = {
          "Hard" = 104583;
          "Name" = "nofile";
          "Soft" = 104583;
        };
      };
    };
    extraOptions = "--userns-remap=${username}";
  };

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # List services that you want to enable:

  # Enable the OpenSSH daemon.
  # services.openssh.enable = true;

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # This value determines the NixOS release from which the default
  # settings for stateful data, like file locations and database versions
  # on your system were taken. It‘s perfectly fine and recommended to leave
  # this value at the release version of the first install of this system.
  # Before changing this value read the documentation for this option
  # (e.g. man configuration.nix or on https://nixos.org/nixos/options.html).
  system.stateVersion = "21.11"; # Did you read the comment?
  networking.networkmanager = {
    enable = true;
  };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    settings = {
      General = {
        # Shows battery charge of connected devices on supported
        # Bluetooth adapters. Defaults to 'false'.
        Experimental = true;
        # When enabled other devices can connect faster to us, however
        # the tradeoff is increased power consumption. Defaults to
        # 'false'.
        FastConnectable = true;
      };
      Policy = {
        # Enable all controllers when they are found. This includes
        # adapters present on start as well as adapters that are plugged
        # in later on. Defaults to 'true'.
        AutoEnable = true;
      };
    };
    # package = pkgs.bluez;
  };
  services.blueman.enable = true;
  # services.blueman = { enable = true; };
  # specialisation = {
  # 	external-display.configuration = {
  #       	system.nixos.tags = [ "external-display" ];
  #       	hardware.nvidia.prime.offload.enable = pkgs.lib.mkForce false;
  #       	hardware.nvidia.prime.sync.enable = pkgs.lib.mkForce true;
  #       	hardware.nvidia.powerManagement.enable = pkgs.lib.mkForce false;
  #       	hardware.nvidia.powerManagement.finegrained = pkgs.lib.mkForce false;
  #       };
  # };
}
