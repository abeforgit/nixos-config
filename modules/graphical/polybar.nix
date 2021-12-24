{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.polybar;
in {
  options.custom.polybar = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      services.polybar = {
        enable = true;
        script = ''
          polybar bar1 &
        '';
        settings = {
          bar1 = {
            # modules-left = "bspwm";
          };

        };
      };

    };

  };

}
