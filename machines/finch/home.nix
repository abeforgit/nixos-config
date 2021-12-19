{ config, pkgs, home, programs, services, ...}:
{
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
		enable = true;
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
}
