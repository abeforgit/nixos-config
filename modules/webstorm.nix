{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.webstorm;
in {
  imports = [ ./jetbrains-core.nix ];
  options.custom.webstorm = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {

    home-manager.users.${config.custom.user} = let
      devSDKs = with pkgs; {
        node = nodejs;
        node14 = nodejs-14_x;
        node16 = nodejs-16_x;
      };
      extraPath = makeBinPath (builtins.attrValues devSDKs);
      webstorm = pkgs.runCommand "webstorm" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
              mkdir -p $out/bin
              makeWrapper ${pkgs.jetbrains.webstorm}/bin/webstorm \
                $out/bin/webstorm \
                --prefix PATH : ${extraPath}
        #     '';
    in { ... }: {
      home.packages = with pkgs; [
        webstorm
        google-chrome
        fontconfig
        dejavu_fonts
        nerdfonts
        font-manager
      ];
      fonts.fontconfig.enable = true;
      home.file.".local/webstorm-dev".source = let
        mkEntry = name: value: {
          inherit name;
          path = value;
        };
        entries = mapAttrsToList mkEntry devSDKs;
      in pkgs.linkFarm "local-dev" entries;
    };
  };

}
