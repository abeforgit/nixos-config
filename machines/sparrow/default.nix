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
  openrgb = pkgs.openrgb-with-all-plugins;
in
{
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.supportedFilesystems = [ "ntfs" ];
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  #  boot.loader.grub.useOSProber = true;
  #  boot.loader.grub.default = "saved";
  #  boot.loader.grub.fontSize = 32;
  #  boot.loader.grub.font = pkgs.hack-font;
  # make appimages work ootb
  boot.binfmt.registrations.appimage = {
    wrapInterpreterInShell = false;
    interpreter = "${pkgs.appimage-run}/bin/appimage-run";
    recognitionType = "magic";
    offset = 0;
    mask = "\\xff\\xff\\xff\\xff\\x00\\x00\\x00\\x00\\xff\\xff\\xff";
    magicOrExtension = "\\x7fELF....AI\\x02";
  };

  networking.hostName = "sparrow"; # Define your hostname.
  #     127.0.0.1 register.reglementairebijlage.vlaanderen.be
  #     127.0.0.1 register.reglementairebijlagen.vlaanderen.be
  #      127.0.0.1 gelinkt-notuleren.lblod.info
  networking.extraHosts = ''
    127.0.0.1 gn.localhost
    127.0.0.2 publication.localhost
  '';
  networking.networkmanager = {
    enable = true;
  };
  networking.interfaces.enp8s0.useDHCP = true;
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # services.xserver.enable = true;
  # services.xserver.displayManager.gdm.enable = true;
  # services.xserver.desktopManager.gnome.enable = true;
  services.hardware.openrgb = {
    enable = true;
    package = openrgb;
  };

  services.xserver = {
    xkb = {
      options = "eurosign:e";
      layout = "us";
    };
    dpi = 192;
  };
  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #  font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };
  nix.package = pkgs.nixVersions.latest;

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
  # services.gnome.gnome-settings-daemon.enable = true;
  # Enable the X11 windowing system.

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  # nixpkgs.config = {
  #   permittedInsecurePackages = [ "electron-21.4.0" "openssl-1.1.1w" ];

  #   allowUnfree = true;
  #   allowUnfreePredicate = (pkg: true);
  #   # cudaSupport = true;
  # };
  # Enable sound.

  # Enable touchpad support (enabled default in most desktopManager).

  # Define a user account. Don't forget to set a password with ‘passwd’.

  services.udev.packages = [ oryx_udev ];
  services.gvfs.enable = true;

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
  networking.firewall.enable = false;

  fonts = {
    enableDefaultPackages = true;
    fontconfig = {
      enable = true;
    };
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

  # sound.enable = true;
  hardware.pulseaudio.enable = false;
  security.rtkit.enable = true;

  programs.noisetorch.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # If you want to use JACK applications, uncomment this
    jack.enable = true;
    wireplumber = {
      enable = true;
    };

    # use the example session manager (no others are packaged yet so this is enabled by default,
    # no need to redefine it in your config for now)
    #media-session.enable = true;
  };
  custom.graphical.enable = true;
  custom.user = username;
  custom.emacs.enable = true;
  custom.zsh.enable = true;
  custom.vscode.enable = true;
  custom.nvim.enable = true;
  custom.git.enable = true;
  custom.wezterm.enable = true;
  custom.hostname = "sparrow";
  custom.keychain.enable = true;
  custom.extraHomePackages = with pkgs; [
    thunderbird
    discord
    btop
    cachix
    # cudatoolkit
    filezilla
    idasen
    # calibre
    anytype
    evince
    lorien
    nvd
    signal-desktop
    powertop
    anki-bin
    usbutils
    bitwarden
    rofi
    rbw
    rofi-rbw
    git-subrepo
    pinentry-curses
    dig.dnsutils
    dnstop
    dnstracer
    dnsperf
    pinta
    lazydocker
    galaxy-buds-client
    spotify
    ## hypr
    tofi
    dunst
    xdg-desktop-portal-hyprland
    xdg-desktop-portal-gtk
    libsForQt5.polkit-kde-agent
    libsForQt5.qt5.qtwayland
    qt6.qtwayland
    qt6ct
    xwayland
    nwg-look
    waybar
    udiskie
    hyprpaper
    hypridle
    hyprlock
    nix-output-monitor

    #from kde TODO
    fira-code
    vlc
    smbmap
    smbscan
    samba
    libsForQt5.kdenetwork-filesharing
    packagekit

    ffmpeg_6
  ];

  custom.extraSystemPackages = with pkgs; [
    sqlite
    tailspin
    udiskie
    ntfs3g
    monaspace
    fira-code
    (giph.override { ffmpeg = ffmpeg-full; })
    vokoscreen
    vokoscreen-ng
    simplescreenrecorder
    tdrop

    wl-clipboard
    cliphist
    slurp
    grim
    watershot
    satty
    libsForQt5.networkmanager-qt
    libsForQt5.breeze-qt5
    libsForQt5.breeze-gtk
    libsForQt5.breeze-icons
    adwaita-qt
    adwaita-qt6
    adwaita-icon-theme

    pavucontrol
    alsaUtils
    alsa-tools
    qjackctl
    libsForQt5.kdenetwork-filesharing
    nfs-utils
    cifs-utils
    smbmap
    smbscan
    dconf-editor
    glib
    libinput
    copyq

    gparted
    lxappearance

    xournalpp
    rnote
  ];
  programs.steam = {
    enable = true;
  };
  security.wrappers."mount.nfs" = {
    setuid = true;
    owner = "root";
    group = "root";
    source = "${pkgs.nfs-utils.out}/bin/mount.nfs";
  };
  services.samba-wsdd = {
    # make shares visible for Windows clients
    enable = true;
  };
  services.samba = {
    enable = true;
    extraConfig = ''
      workgroup = WORKGROUP
      server string = sparrow
      netbios name = sparrow
      usershare path = /var/lib/samba/usershares
      usershare max shares = 100
      usershare allow guests = yes
      usershare owner only = yes
      guest account = arne
      map to guest = Bad Password
    '';
  };
  users.users.arne = {
    shell = pkgs.zsh;
  };
  hardware.logitech.wireless = {
    enable = true;
    enableGraphical = true;
  };
  systemd.extraConfig = ''
    DefaultTimeoutStopSec=10s
  '';

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
  system.stateVersion = "23.11"; # Did you read the comment?
  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluez;
  };
  programs.hyprland.enable = true;
  programs.dconf.enable = true;
  programs.nix-ld.enable = true;

  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
    POLKIT_BIN = pkgs.libsForQt5.polkit-kde-agent;
    GDK_BACKEND = "wayland,x11";
    QT_QPA_PLATFORM = "wayland;xcb";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";
    QT_AUTO_SCREEN_SCALE_FACTOR = "1";
    NIXOS_OZONE_WL = "1";
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  services.displayManager = {
    sddm.enable = true;
    sddm.wayland.enable = true;
  };
  home-manager.users.arne =
    { pkgs, home, ... }:
    {
      programs.zsh.profileExtra = ''
        source ${config.age.secrets.github_auth.path}
        source ${config.age.secrets.jira_pat.path}
      '';

      home.pointerCursor = {
        gtk.enable = true;
        x11.enable = true;
        package = pkgs.nordzy-cursor-theme;
        name = "Nordzy-cursors";
        size = 24;
      };

      programs.obs-studio = {
        enable = true;
        plugins = with pkgs.obs-studio-plugins; [
          input-overlay
          wlrobs
        ];
      };
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
