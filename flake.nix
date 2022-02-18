{
  description = "NixOS Configurattion";
  inputs = {
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      flake = false;
    };
    nix-doom-emacs = {
      url =
        "github:nix-community/nix-doom-emacs?rev=f7a7a154f2335bd673116a6f38a45f974559f9aa";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.emacs-overlay.follows = "emacs-overlay";

    };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-unstable-small
    , home-manager, nix-doom-emacs, utils, agenix }:
    let
      customPackages = callPackage: {
        jetbrains-jre-jcef = callPackage ./packages/jetbrains-jre-jcef { };

      };
    in utils.lib.mkFlake {

      inherit self inputs;
      channels.master = {
        input = nixpkgs-master;

      };
      channels.small = {
        input = nixpkgs-unstable-small;

      };

      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = channels: [
          (self: super: customPackages self.callPackage)
          (self: super: {
            inherit (channels.small) kitty;
            inherit (channels.small) remarshal;
          })
        ];
      };
      hostDefaults = {

        modules = [
          ({
            config._module.args = {
              inherit nix-doom-emacs;
              agenix-cli = agenix.defaultPackage.x86_64-linux;
            };
          })
          { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          (./modules)
          (./machines/finch)
          agenix.nixosModules.age
        ];

      };
      hosts = { finch.modules = [ ./machines/finch ]; };
      outputsBuilder = channels:
        let pkgs = channels.nixpkgs;
        in {
          packages = customPackages pkgs.callPackage;

        };
    };

}
