# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, lib, ... }:

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
SUBSYSTEM=="usb", ATTR{idVendor}=="3297", ATTR{idProduct}=="1969", GROUP="plugdev"
'';
    destination = "/etc/udev/rules.d/50-oryx.rules";
  };
in {
  imports = [ # Include the results of the hardware scan.
    ./hardware-configuration.nix
  ];

  boot.extraModprobeConfig = ''
    options hid_apple swap_opt_cmd=1
    options hid_apple swap_fn_leftctrl=1
    options hid_apple fnmode=2
  '';
  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "finch"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # The global useDHCP flag is deprecated, therefore explicitly set to false here.
  # Per-interface useDHCP will be mandatory in the future, so this generated config
  # replicates the default behaviour.
  networking.useDHCP = false;
  networking.interfaces.enp0s31f6.useDHCP = true;
  networking.interfaces.wlp82s0.useDHCP = true;

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  # Select internationalisation properties.
  # i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #  font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.

  # Enable CUPS to print documents.
  # services.printing.enable = true;
  nixpkgs.config = {
    permittedInsecurePackages = [ "xen-4.10.4" ];

    allowUnfree = true;
    allowUnfreePredicate = (pkg: true);
  };
  # Enable sound.

  # Enable touchpad support (enabled default in most desktopManager).

  # Define a user account. Don't forget to set a password with ‘passwd’.

  services.udev.packages = [ brightness_udev oryx_udev ];
  services.gvfs.enable = true;
  environment.variables = {
    GDK_SCALE = "2";
    GDK_DPI_SCALE = "0.5";
    _JAVA_OPTIONS = "-Dsun.java2d.uiScale=2";
  };

  services.xserver = {
    videoDrivers = [ "nvidia" ];
    dpi = 192;
    layout = "us";
    xkbOptions = "eurosign:e";
    screenSection = ''
      Option         "metamodes" "nvidia-auto-select +0+0 {ForceFullCompositionPipeline=On}"
      Option         "AllowIndirectGLXProtocol" "off"
      Option         "TripleBuffer" "o
    '';
  };

  services.postgresql = { enable = true; };
  boot.kernelParams = [ "i915.enable_dcpcd_backlight=1" ];
  hardware.nvidia = {
    nvidiaSettings = true;
    modesetting.enable = true;
    prime = {
      sync.enable = true;
      intelBusId = "PCI:0:2:0";
      nvidiaBusId = "PCI:1:0:0";
    };
  };
  age.secrets = {
    github_auth = {
      file = ../../secrets/github_auth.age;
      owner = config.custom.user;
    };

  };

  home-manager.users.arne = { pkgs, home, ... }: {
    programs.zsh.profileExtra = ''
      source ${config.age.secrets.github_auth.path}
    '';
  };

  custom.user = username;
  custom.graphical.enable = true;
  custom.emacs.enable = true;
  custom.zsh.enable = true;
  custom.vscode.enable = true;
  custom.keychain.enable = true;
  custom.keyring.enable = true;
  custom.audio.enable = true;
  custom.nvim.enable = true;
  custom.git.enable = true;
  custom.intellij.enable = true;
  custom.webstorm.enable = true;
  custom.rustup.enable = false;
  custom.hostname = "finch";
  custom.rider.enable = true;
  custom.extraHomePackages = with pkgs; [
    thunderbird
    discord
    btop
    filezilla
    calibre
    evince
    godot-mono
  ];
  custom.extraSystemPackages = with pkgs; [
    sqlite
  ];
  users.users.arne = { shell = pkgs.zsh; };

  # List packages installed in system profile. To search, run:
  # $ nix search wget
  virtualisation.docker = {
    enable = true;
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
  networking.networkmanager = { enable = true; };

  hardware.bluetooth = {
    enable = true;
    powerOnBoot = true;
    package = pkgs.bluezFull;
  };
  services.blueman = { enable = true; };
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

