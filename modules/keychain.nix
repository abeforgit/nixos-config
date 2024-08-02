{ config, lib, pkgs, ... }:

with lib;
let cfg = config.custom.keychain;
in {

  options.custom.keychain = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, home, ... }: {
      programs.keychain = {
        enable = true;
        enableZshIntegration = true;
        extraFlags = [ "--quiet" "--nogui"]
      };
    };


  };
}
