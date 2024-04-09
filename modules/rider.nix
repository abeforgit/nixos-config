{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.rider;
in {
  imports = [ ./jetbrains-core.nix ];
  options.custom.rider = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = let
      devSDKs = with pkgs; {
        dotnet = dotnetCorePackages.sdk_7_0;
        mono = mono;
        mono5 = mono5;
        # godot-mono = godot-mono;
      };
      extraPath = makeBinPath (builtins.attrValues devSDKs);
      rider = pkgs.runCommand "rider" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.jetbrains.rider}/bin/rider \
          $out/bin/rider \
          --prefix PATH : ${extraPath}
      '';
    in { ... }: {
      home.packages = [ rider ];
      home.file.".local/rider-dev".source = let
        mkEntry = name: value: {
          inherit name;
          path = value;
        };
        entries = mapAttrsToList mkEntry devSDKs;
      in pkgs.linkFarm "local-dev" entries;
    };
  };

}
