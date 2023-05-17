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
#    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    comma.url = "github:nix-community/comma";
    nix-alien = {
      url = "github:thiagokokada/nix-alien";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    stylix.url = "/home/arne/repos/stylix";
    # nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
#    nixpkgs-stable.url = "github:NixOS/nixpkgs/nixos-22.11";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    utils = {
      url = "github:ravensiris/flake-utils-plus/7a8d789d4d13e45d20e6826d7b2a1757d52f2e13";
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
    rust-overlay = { url = "github:oxalica/rust-overlay"; };
  };

  outputs = inputs@{ self, nixpkgs,
#  nixpkgs-master,
#  nixpkgs-stable,
    home-manager, utils, agenix, emacs-overlay, devshell, flake-utils
    , rust-overlay, blender-bin, comma, nix-alien, stylix }:
    let
      customPackages = callPackage:
        {

        };
    in utils.lib.mkFlake {

      inherit self inputs;
#      channels.master = {
#        input = nixpkgs-master;
#        config = { allowUnfree = true; };
#
#      };
      # channels.small = {
      #   input = nixpkgs-unstable-small;

      # };

      channels.nixpkgs = {
        input = nixpkgs;
        config = { allowUnfree = true; };
        overlaysBuilder = channels: [
          devshell.overlays.default
          emacs-overlay.overlay
          rust-overlay.overlays.default
          nix-alien.overlays.default
          blender-bin.overlays.default
          # (self: super: {
          #   inherit (channels.master) spotify;
          # })
          # (import (builtins.fetchTarball {

          #   url =
          #     "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
          #   sha256 = "0m443p0lp2pmkgy0a8lizbvy2ia44zpqli422s34hpnqvzxyj2mj";

          # }))
          # dan-flk.overlays."nixos/spotify"
          # (final: prev: {

          #   blender = prev.blender.override { cudaSupport = true; };
          # })
          #          (final: prev: {
          #            jetbrains = prev.jetbrains // {
          #              jdk = final.callPackage ./packages/p-jetbrains-jdk-bin { };
          #            };
          #          })
          (self: super: {
            godot-mono = with super;
              let
                arch = "64";
                version = "3.5.1";
                releaseName = "stable";
                subdir = "";
                pkg = stdenv.mkDerivation {
                  name = "godot-mono-unwrapped";
                  buildInputs = [ unzip ];
                  unpackPhase = "unzip $src";
                  version = version;
                  src = fetchurl {
                    url =
                      "https://downloads.tuxfamily.org/godotengine/${version}${subdir}/mono/Godot_v${version}-${releaseName}_mono_x11_${arch}.zip";
                    sha256 =
                      "sha256-7phG4vgq4m0h92gCMPv5kehQQ1BH7rS1c5VZ6Dx3WPc=";
                  };
                  installPhase = ''
                    cp -r . $out
                  '';
                };
              in buildFHSUserEnv {
                name = "godot-mono";
                targetPkgs = pkgs:
                  (with pkgs; [
                    alsa-lib
                    dotnetCorePackages.sdk_7_0
                    libGL
                    libpulseaudio
                    udev
                    xorg.libX11
                    xorg.libXcursor
                    xorg.libXext
                    xorg.libXi
                    xorg.libXinerama
                    xorg.libXrandr
                    xorg.libXrender
                    zlib
                  ]);
                runScript =
                  "${pkg.outPath}/Godot_v${version}-${releaseName}_mono_x11_${arch}/Godot_v${version}-${releaseName}_mono_x11.${arch}";
              };
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
          stylix.nixosModules.stylix
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
          devShells = let
            ls = builtins.readDir ./shells;
            files = builtins.filter (name: ls.${name} == "regular")
              (builtins.attrNames ls);
            shellNames = builtins.map
              (filename: builtins.head (builtins.split "\\." filename)) files;
            nameToValue = name:
              import (./shells + "/${name}.nix") { inherit pkgs inputs; };
          in builtins.listToAttrs (builtins.map (name: {
            inherit name;
            value = nameToValue name;
          }) shellNames);

        };
    };

}
