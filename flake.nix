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
    nix-doom-emacs = { url = "github:nix-community/nix-doom-emacs"; };
    utils.url = "github:gytis-ivaskevicius/flake-utils-plus";
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgs-master, nixpkgs-unstable-small
    , home-manager, nix-doom-emacs, utils, agenix, emacs-overlay }:
    let
      customPackages = callPackage: {

        customPackages = callPackage: {
          spotify-spicetified =
            callPackage (import ./packages/spotify-spicetified) { };
        };
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
            tdrop = let version = "ca08ab9371eda3ba19b4857ee337b371cb95c56c";
            in super.tdrop.overrideAttrs (old: {
              inherit version;
              src = super.fetchFromGitHub {
                owner = "noctuid";
                repo = "tdrop";
                rev = version;
                sha256 = "sha256-d5YaRH0D3G05eWjHWJjEK/FIulyeb2JaQv3fjqyw6ks=";
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
