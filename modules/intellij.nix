{ config, lib, pkgs, ... }:
with lib;
let cfg = config.custom.intellij;
in {
  options.custom.intellij = {
    enable = mkOption {
      example = true;
      default = false;
    };
  };
  config = mkIf cfg.enable {
    home-manager.users.${config.custom.user} = let
      devSDKs = with pkgs; {
        rustc = synlinkJoin {
          name = rustc.pname;
          paths = [ rustc cargo gcc ];
        };
        rust-src = rust.packages.stable.rustPlatform.rustLibSrc;
        java11 = jdk11;
        java = jdk;
        python = python3;

      };
      extraPath = makeBinPath (builtins.attrValues devSDKs);
      intellij = pkgs.runCommand "intellij" {
        nativeBuildInputs = [ pkgs.makeWrapper ];
      } ''
        mkdir -p $out/bin
        makeWrapper ${pkgs.jetbrains.idea-ultimate}/bin/idea-ultimate \
          $out/bin/intellij \
          --prefix PATH : ${extraPath}
      '';
    in { ... }: {
      home.packages = [ intellij ];
      home.file.".local/dev".source = let
        mkEntry = name: value: {
          inherit name;
          path = value;
        };
        entries = mapAttrsToList mkEntry devSDKs;
      in pkgs.linkFarm "local-dev" entries;

    };
  };

}
