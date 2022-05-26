{
  description = "NixOS Configurattion";
  inputs = {
    dan-flk.url = "github:danielphan2003/flk";
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
    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-unstable-small
    , home-manager, nix-doom-emacs, utils, agenix, emacs-overlay, dan-flk }:
    let customPackages = callPackage: { };
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
          # (import (builtins.fetchTarball {

          #   url =
          #     "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
          #   sha256 = "0m443p0lp2pmkgy0a8lizbvy2ia44zpqli422s34hpnqvzxyj2mj";

          # }))
          # dan-flk.overlays."nixos/spotify"
          (import emacs-overlay)
          (self: super: {
            inherit (channels.small) kitty;
            inherit (channels.small) remarshal;
          })
          (self: super: {
            spotify-spicetified =
              dan-flk.packages.x86_64-linux.spotify-spicetified;
            dribbblish-dynamic-theme =
              dan-flk.packages.x86_64-linux.dribbblish-dynamic-theme;
          })
          (overlayFinal: overlayPrev:
            let
              packageOverrides = (pythonFinal: pythonPrev: {
                apsw = pythonPrev.apsw.overridePythonAttrs (oldAttrs: {
                  version = "3.38.1-r1";
                  src = overlayPrev.fetchFromGitHub {
                    owner = "rogerbinns";
                    repo = "apsw";
                    rev = "3.38.1-r1";
                    sha256 =
                      "sha256-pbb6wCu1T1mPlgoydB1Y1AKv+kToGkdVUjiom2vTqf4=";
                  };
                  checkInputs = [ ];
                  # Project uses custom test setup to exclude some tests by default, so using pytest
                  # requires more maintenance
                  # https://github.com/rogerbinns/apsw/issues/335
                  checkPhase = ''
                    python tests.py
                  '';
                  pytestFlagsArray = [ ];
                  disabledTests = [ ];
                });
              });
              python' =
                overlayPrev.python3.override { inherit packageOverrides; };
            in {
              calibre = overlayPrev.calibre.override {
                python3Packages = python'.pkgs;
              };
            })
          (self: super: {
            herbstluftwm = let version = "0.9.4";
            in super.herbstluftwm.overrideAttrs (old: {
              inherit version;
              src = super.fetchurl {
                url =
                  "https://herbstluftwm.org/tarballs/herbstluftwm-${version}.tar.gz";
                sha256 = "sha256-7vju0HavM68qdZEcD7EhX9s0J2BqA06otE/naHLLA8w=";
              };
              doCheck = false;
              buildInputs = old.buildInputs
                ++ [ super.xorg.libXdmcp super.xorg.libXfixes ];
            });

          })
          (self: super: {
            tdrop = let version = "797cc3626a3b8560297c3f08132c2670c3040f40";
            in super.tdrop.overrideAttrs (old: {
              inherit version;
              src = super.fetchFromGitHub {
                owner = "noctuid";
                repo = "tdrop";
                rev = version;
                sha256 = "sha256-fHvGXaZL7MMvTnkap341B79PDDo2lOVPPcOH4AX/zXo=";
              };
            });
          })
          (self: super: {
            godot-mono = with super;
              let
                arch = "64";
                version = "3.4.3";
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
                      "sha256-VfJQ22q/4EuNwS7B+VSFqUw2NwtaUXTU6euuklbB9rw=";
                  };
                  installPhase = ''
                    cp -r . $out
                  '';
                };
              in buildFHSUserEnv {
                name = "godot-mono";
                targetPkgs = pkgs:
                  (with pkgs; [
                    alsaLib
                    dotnetCorePackages.sdk_5_0
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
