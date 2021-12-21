{ config, lib, pkgs, ... }:

with lib;

let cfg = config.custom.keyring;
in {
  options = {
    custom.keyring.enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {
    services.gnome.gnome-keyring.enable = true;
    programs.seahorse.enable = true;

  };

}
