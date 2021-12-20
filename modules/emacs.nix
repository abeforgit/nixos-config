{ pkgs, config, lib, ...}:
with lib;
let cfg = config.custom.emacs;
in {
	options.custom.emacs = {
		enable = mkOption {
			example = true;
			default = false;
		};
	};
	config = mkIf cfg.enable {
		home-manager.users.${config.custom.user} = {pkgs, ...}: {
			imports = [ nix-doom-emacs.hmModule ];
			programs.doom-emacs = {
				enable = true;
				doomPrivateDir = .doom.d;
			};
		};
	};
}
