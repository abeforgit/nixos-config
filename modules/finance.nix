{
  config,
  lib,
  pkgs,
  ...
}:
with lib;
let
  cfg = config.custom.finance;
in
{
  options.custom.finance = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {

    home-manager.users.${config.custom.user} =
      { pkgs, home, ... }:
      {
        home.packages = with pkgs; [

          hledger
          hledger-fmt
          hledger-ui
          hledger-web

          beancount
          fava
        ];
      };

  };

}
