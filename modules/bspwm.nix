{ pkgs, config, lib, ... }:
with lib;
let cfg = config.custom.bspwm;
in {
	options.custom.bspwm = {
		enable = mkOption {
			example = true;
			default = false;
			};
	};
	config = mkIf cfg.enable {
		home-manager.users.${config.custom.user} = { pkgs, ...}: {
			xsession = {
				enable = true;
				windowManager.bspwm = {
					enable = true;
					settings = {
						border_width = 10;
						window_gap = 12;
						split_ratio = 0.52;
						borderless_monocle = true;
						gapless_monocle = true;
						focus_follows_pointer = true;
						pointer_follows_monitor = true;

					};
					monitors = {
						"^1" = [ "I" ];
						"^2" = [ "II" ];
					};
				};
				scriptPath = ".hm-xsession";
			};
			services.sxhkd = {
				enable = true;
				keybindings = {
					"super + Return" = "kitty";
					"super + {_,shift + } {h,j,k,l}" = "bspc node -{f, s} {west, south, north, east}";
					"super + shift + q" = "bspc node -c";
					"super + {1-2}" = "bspc desktop -f '{I,II}'";
					"super + d" = "rofi -show combi";
					"super + space; r; s" = "pkill -USR1 -x sxhkd";
				};
			};
		};
	};
}
	
