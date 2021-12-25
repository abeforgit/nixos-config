{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.rustup;
in {
  options.custom.rustup = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ rustup ];
      home.sessionPath = [ "$HOME/.local/bin" ];
      home.sessionVariables = { RUSTBIN = "$HOME/.local/bin"; };
    };
  };
}
