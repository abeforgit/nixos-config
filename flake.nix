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
    activitywatch.url = "path:flakes/activitywatch";
  };

  outputs = inputs@{ self, nixpkgs, home-manager, nix-doom-emacs, activitywatch
    , utils }:
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
              inherit activitywatch;
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
