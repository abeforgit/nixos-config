{ pkgs, config, lib, ... }:
let cfg = config.custom.bspwm;
in {
	config = mkIf cfg.enable {
		home-manager.users.${config.custom.user} = { pkgs, ...}: {
			xsession = {
				enable = true;
				windowManager.bspwm = {
					enable = true;
				};
			};
			services.sxhkd = {
				enable = true;
				keybindings = {
					"super + Return" = "kitty";
					"super + {_,shift + } {h,j,k,l}" = "bspc node -{f, s} {west, south, north, east};
					"super + shift + q" = "bspc node -c";
				}
			};
		}
	};
}
	
