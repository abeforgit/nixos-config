{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.custom.syncthing;
in
{
  options = {
    custom.syncthing.enable = mkOption {
      example = true;
      default = false;
    };

  };
  config = mkIf cfg.enable {

    services.syncthing = {
      enable = true;
      user = config.custom.user;
      group = config.custom.user;
      dataDir = "/home/${config.custom.user}/syncthing";
      configDir = "/home/${config.custom.user}/.config/syncthing";

    };
    # home-manager.users.${config.custom.user} =
    #   { pkgs, ... }:
    #   {
    #
    #   };

  };

}
