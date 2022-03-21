{
  description = "tdrop master build";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    tdrop.url = "github:noctuid/tdrop"
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-unstable-small
    , home-manager, nix-doom-emacs, utils, agenix, emacs-overlay }:
    let
      customPackages = callPackage:
        {

        };
    in utils.lib.mkFlake {

      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];
    };
}
