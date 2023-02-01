{ config, lib, pkgs, ... }:
with lib;
let
  cfg = config.custom.webstorm;
  webstormPkg = pkgs.jetbrains.webstorm.overrideAttrs (old: {
    version = "2022.3.2";
    jdk = pkgs.jetbrains.jdk;
    src = pkgs.fetchurl {
      sha256 = "sha256-K2Ehd8mf8MbFQqvgBYRsOqbPFw+qAgLar+tKsWJ8N5Q=";
      url = "https://download.jetbrains.com/webstorm/WebStorm-2022.3.2.tar.gz";
    };

  });
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
        pandoc = pandoc;
      };
      extraPath = makeBinPath (builtins.attrValues devSDKs);
      webstorm = pkgs.runCommand "webstorm" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
              mkdir -p $out/bin
              makeWrapper ${ webstormPkg }/bin/webstorm \
                $out/bin/webstorm \
                --prefix PATH : ${extraPath}
        #     '';
    in { ... }: {
      home.packages = with pkgs; [
        webstorm
        pandoc
        google-chrome
        fontconfig
        dejavu_fonts
        nerdfonts
        font-manager
      ];
      xdg.desktopEntries = {
        webstorm = {
          name = "Webstorm";
          exec = "webstorm %U";
          icon = "${webstormPkg}/share/pixmaps/webstorm.svg";
          terminal = false;
          categories = [ "Development" "IDE" ];
          type = "Application";

        };
      };
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
