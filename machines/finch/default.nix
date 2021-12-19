# Edit this configuration file to define what should be installed on
# your system.  Help is available in the configuration.nix(5) man page
# and in the NixOS manual (accessible by running ‘nixos-help’).

{ config, pkgs, ... }:

let
  nvidia-offload = pkgs.writeShellScriptBin "nvidia-offload" ''
    export __NV_PRIME_RENDER_OFFLOAD=1
    export __NV_PRIME_RENDER_OFFLOAD_PROVIDER=NVIDIA-G0
    export __GLX_VENDOR_LIBRARY_NAME=nvidia
    export __VK_LAYER_NV_optimus=NVIDIA_only
    exec -a "$0" "$@"
  '';
in
{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
      <home-manager/nixos>
    ];

  # Use the systemd-boot EFI boot loader.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;
  boot.loader.grub.useOSProber = true;

  networking.hostName = "nixforabe"; # Define your hostname.
  # networking.wireless.enable = true;  # Enables wireless support via wpa_supplicant.

  # Set your time zone.
  time.timeZone = "Europe/Brussels";

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
  #   font = "Lat2-Terminus16";
  #   keyMap = "us";
  # };

  # Enable the X11 windowing system.


  


  # Enable CUPS to print documents.
  # services.printing.enable = true;
  nixpkgs.config.allowUnfree = true;
  # Enable sound.
  sound.enable = true;
  hardware.pulseaudio.enable = true;

  # Enable touchpad support (enabled default in most desktopManager).

  # Define a user account. Don't forget to set a password with ‘passwd’.
  users.users.arne = {
    createHome = true;
    group = "arne";
    isNormalUser = true;
    extraGroups = [ "wheel" "networkmanager" "docker"]; # Enable ‘sudo’ for the user.
  };
  users.groups.arne = {};

  home-manager.useGlobalPkgs = true;
  home-manager.useUserPackages = true;
  home-manager.users.arne = {
	home.packages = [ 
		pkgs.httpie 
		pkgs.firefox
		pkgs.fira-code
		pkgs.pciutils
		pkgs.blueman
		pkgs.tdrop
		pkgs.docker-compose
		pkgs.bat
		pkgs.xfce.thunar
		pkgs.xfce.thunar-volman
		pkgs.xfce.thunar-archive-plugin
		pkgs.xfce.thunar-media-tags-plugin
		pkgs.arandr
	];
	services.udiskie = {
		enable = true;
		automount = true;
		notify = true;
		tray = "auto";
	};
	programs.git = {
		userName = "abeforgit";
		userEmail = "arnebertrand@gmail.com";
	};
	programs.autorandr = {
		enable = true;
		profiles = {
			"home" = {
				fingerprint = {
					eDP1 = "00ffffffffffff0009e50908000000001e1c0104b523137802df50a35435b5260f50540000000101010101010101010101010101010150d000a0f0703e803020350058c21000001aa6a600a0f0703e803020350058c21000001a000000fe00424f452048460a202020202020000000fe004e4531353651554d2d4e36360a019202030f00e3058000e606050160602800000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000000aa";
					HDMI0 = "00ffffffffffff0005e39027bd210000221e0103803c22782a67a1a5554da2270e5054bfef00d1c0b30095008180814081c0010101014dd000a0f0703e803020350055502100001aa36600a0f0701f803020350055502100001a000000fc005532373930420a202020202020000000fd0017501ea03c000a20202020202001c8020333f14c9004031f1301125d5e5f606123090707830100006d030c001000387820006001020367d85dc401788003e30f000c565e00a0a0a029503020350055502100001e023a801871382d40582c450055502100001e011d007251d01e206e28550055502100001e4d6c80a070703e8030203a0055502100001a000000004e";
				 


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
		};
	};
  	programs.zsh.enable = true;
	programs.rofi = {
		enable = true;
		font = "Fira Code 24";
		theme = "Monokai";
	};
	services.polybar = {
		enable = false;
	};

	programs.kitty = {
		enable = true;
		font.name = "Fira Code";
		font.size = 14;
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
  services.picom = {
  	enable = true;
	experimentalBackends = true;
	vSync = true;
  };
  services.gvfs.enable = true;

  # Configure keymap in X11
  services.xserver = {
  	libinput = {
		enable = true;
		touchpad = {
			tapping = true;
			clickMethod = "clickfinger";
			accelProfile = "adaptive";
			accelSpeed = "2";
		};
	};
  	videoDrivers = [ "nvidia" ];
  	dpi = 192;
  	enable = true;
	layout = "us";
	xkbOptions = "eurosign:e";
	windowManager.bspwm = {
		enable = true;
	};
  };
  hardware.nvidia = {
  	nvidiaSettings = true;
	modesetting.enable = true;
  	prime = {
		offload.enable = true; 
		intelBusId = "PCI:0:2:0";
		nvidiaBusId = "PCI:1:0:0";
	};
	powerManagement = {
		enable = true;
		finegrained = true;
	};
  };
  # List packages installed in system profile. To search, run:
  # $ nix search wget
  environment.systemPackages = with pkgs; [
    neovim # Do not forget to add an editor to edit configuration.nix! The Nano editor is also installed by default.
    wget
    kitty
    nvidia-offload
    git
    git-lfs
    killall
    ntfs3g
    sxhkd
  ];
  virtualisation.docker = {
  	enable = true;
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
  };
  specialisation = {
  	external-display.configuration = {
        	system.nixos.tags = [ "external-display" ];
        	hardware.nvidia.prime.offload.enable = pkgs.lib.mkForce false;
        	hardware.nvidia.prime.sync.enable = pkgs.lib.mkForce true;
        	hardware.nvidia.powerManagement.enable = pkgs.lib.mkForce false;
        	hardware.nvidia.powerManagement.finegrained = pkgs.lib.mkForce false;
        };
  };

}

