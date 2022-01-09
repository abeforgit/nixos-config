{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.webstorm;
in {
  options.custom.webstorm = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = { pkgs, ... }: {
      home.packages = with pkgs; [ nodejs nodejs-14_x jetbrains.webstorm ];
    };

    # for future reference
    #   home-manager.users.${config.custom.user} = let
    #     devSDKs = with pkgs; {
    #     };
    #     extraPath = makeBinPath (builtins.attrValues devSDKs);
    #     webstorm = pkgs.runCommand "webstorm" {
    #       nativeBuildInputs = [ pkgs.makeWrapper ];
    #     } ''
    #       mkdir -p $out/bin
    #       makeWrapper ${pkgs.jetbrains.webstorm}/bin/webstorm \
    #         $out/bin/webstorm \
    #         --prefix PATH : ${extraPath}
    #     '';
    #   in { ... }: {
    #     home.packages = [ webstorm ];
    #     home.file.".local/dev".source = let
    #       mkEntry = name: value: {
    #         inherit name;
    #         path = value;
    #       };
    #       entries = mapAttrsToList mkEntry devSDKs;
    #     in pkgs.linkFarm "local-dev" entries;
    #   };
  };

}
