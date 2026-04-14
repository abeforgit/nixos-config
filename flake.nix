{
  description = "NixOS Configurattion";
  inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    comma.url = "github:nix-community/comma";
    # nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-23.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    blender-bin = {
      url = "github:edolstra/nix-warez?dir=blender";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    wezterm = {
      url = "github:wez/wezterm/main?dir=nix";
    };
    nix-autobahn = {
      url = "github:Lassulus/nix-autobahn";
    };
    nix-alien.url = "github:thiagokokada/nix-alien";
    polymc.url = "github:PolyMC/PolyMC";
    tree-sitter.url = "github:tree-sitter/tree-sitter";

  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      nixpkgs-master,
      nixpkgs-stable,
      home-manager,
      utils,
      agenix,
      emacs-overlay,
      devshell,
      flake-utils,
      rust-overlay,
      blender-bin,
      comma,
      wezterm,
      nix-autobahn,
      polymc,
      nix-alien,
      tree-sitter,
    }:
    let
      customPackages = callPackage: {

      };
    in
    utils.lib.mkFlake {

      inherit self inputs;
      channels.master = {
        input = nixpkgs-master;
        config = {
          allowUnfree = true;
        };

      };
      channels.stable = {
        input = nixpkgs-stable;
        config = {
          allowUnfree = true;
        };

      };

      channels.nixpkgs = {
        input = nixpkgs;
        config = {

          permittedInsecurePackages = [
            "electron-36.9.5"
            "openssl-1.1.1w"
          ];

          allowUnfree = true;
          allowUnfreePredicate = (pkg: true);
        };
        overlaysBuilder = channels: [
          polymc.overlay
          devshell.overlays.default
          emacs-overlay.overlay
          rust-overlay.overlays.default
          blender-bin.overlays.default
          nix-alien.overlays.default
          (self: super: { inherit (channels.stable) galaxy-buds-client; })
          (self: super: {
            utillinux = super.util-linux;
            # inherit (channels.master) wezterm;
            nix-autobahn = nix-autobahn.packages.x86_64-linux.nix-autobahn;
            treesitter-cli = tree-sitter.packages.x86_64-linux.cli;
          })
        ];
      };
      hostDefaults = {

        modules = [

          ({
            config._module.args = {
              agenix-cli = agenix.packages.x86_64-linux.default;
            };
          })
          { nix.nixPath = [ "nixpkgs=${nixpkgs}" ]; }
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
          }
          (./modules)
          agenix.nixosModules.age
        ];
      };
      hosts = {
        finch.modules = [ ./machines/finch ];
        sparrow.modules = [ ./machines/sparrow ];
      };
      outputsBuilder =
        channels:
        let
          pkgs = channels.nixpkgs;
        in
        {
          packages = customPackages pkgs.callPackage;
          devShells =
            let
              ls = builtins.readDir ./shells;
              files = builtins.filter (name: ls.${name} == "regular") (builtins.attrNames ls);
              shellNames = builtins.map (filename: builtins.head (builtins.split "\\." filename)) files;
              nameToValue = name: import (./shells + "/${name}.nix") { inherit pkgs inputs; };
            in
            builtins.listToAttrs (
              builtins.map (name: {
                inherit name;
                value = nameToValue name;
              }) shellNames
            );
        };
    };
}
