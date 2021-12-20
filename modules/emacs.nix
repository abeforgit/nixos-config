{ pkgs, config, lib, ...}:
with lib;
let cfg = config.custom.emacs;
in {
	imports = [ nix-doom-emacs.hmModule ];
	options.custom.emacs = {
		enable = mkOption {
			example = true;
			default = false;
		};
	};
	config = mkIf cfg.enable {
		home-manager.users.${config.custom.user} = {pkgs, ...}: {
			programs.doom-emacs = {
				enable = true;
				doomPrivateDir = ./doom.d;
			};
		};
	};
}
