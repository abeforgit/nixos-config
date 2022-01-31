{
  description = "NixOS Configurattion";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs =
    inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, utils, agenix }:
    let
      customPackages = callPackage: {
        jetbrains-jre-jcef = callPackage ./packages/jetbrains-jre-jcef { };

      };
    in utils.lib.mkFlake {

      inherit self inputs;

      channels.nixpkgs = {
        input = nixpkgs;
        overlaysBuilder = _: [ (self: super: customPackages self.callPackage) ];
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
