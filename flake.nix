{
  description = "NixOS Configurattion";
  inputs = {
    devshell = {
      url = "github:numtide/devshell";
      inputs = {
        flake-utils.follows = "flake-utils";
        nixpkgs.follows = "nixpkgs";
      };
    };
    flake-utils.url = "github:numtide/flake-utils";
    nixpkgs-master.url = "github:NixOS/nixpkgs/master";
    # nixpkgs-unstable-small.url = "github:NixOS/nixpkgs/nixos-unstable-small";
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    nixpkgsReview = { url = "github:ambroisie/nixpkgs/fix-woodpecker-ca"; };
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.utils.follows = "flake-utils";
    };
    emacs-overlay = {
      url = "github:nix-community/emacs-overlay";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.flake-utils.follows = "flake-utils";
    };
    utils = {
      url = "github:gytis-ivaskevicius/flake-utils-plus";
      inputs.flake-utils.follows = "flake-utils";
    };
    agenix = {
      url = "github:ryantm/agenix/main";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    rust-overlay = {
      url = "github:oxalica/rust-overlay";
    };
  };

  outputs = inputs@{ self, nixpkgs, nixpkgsReview, nixpkgs-master,
    # nixpkgs-unstable-small ,
    home-manager, utils, agenix, emacs-overlay, devshell, flake-utils, rust-overlay }:
    let
      customPackages = callPackage:
        {

        };
    in utils.lib.mkFlake {

      inherit self inputs;
      channels.master = {
        input = nixpkgs-master;
        config = { allowUnfree = true; };

      };
      channels.review = {
        input = nixpkgsReview;
        config = { allowUnfree = true; };
      };
      # channels.small = {
      #   input = nixpkgs-unstable-small;

      # };

      channels.nixpkgs = {
        input = nixpkgs;
        config = { allowUnfree = true; };
        overlaysBuilder = channels: [
          devshell.overlay
          emacs-overlay.overlay
          rust-overlay.overlays.default
          # (import (builtins.fetchTarball {

          #   url =
          #     "https://github.com/nix-community/emacs-overlay/archive/master.tar.gz";
          #   sha256 = "0m443p0lp2pmkgy0a8lizbvy2ia44zpqli422s34hpnqvzxyj2mj";

          # }))
          # dan-flk.overlays."nixos/spotify"
          (self: super: {
            # inherit (channels.master) discord;
            inherit (channels.master) woodpecker-cli;
          })
          (final: prev: {
            jetbrains = prev.jetbrains // {
              jdk = final.callPackage ./packages/p-jetbrains-jdk-bin { };
            };
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
                    alsa-lib
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
