{
  description = "tdrop master build";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
  };

  outputs = inputs@{self, nixpkgs}:
    let
      customPackages = callPackage:
        {
          spotify-spicetified = callPackage (import ./packages/spotify-spicetified) {};

        };
    in utils.lib.mkFlake {

      inherit self inputs;
      supportedSystems = [ "x86_64-linux" ];
    };
}
