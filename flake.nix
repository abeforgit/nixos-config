{
  description = "NixOS Configurattion";
  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager/master";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nix-doom-emacs.url = "github:nix-community/nix-doom-emacs";
  };

  outputs = { self, nixpkgs, home-manager, nix-doom-emacs }: {

    nixosConfigurations.finch = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      extraArgs = { inherit nix-doom-emacs; };
      modules = [
        home-manager.nixosModules.home-manager
        {
          home-manager.useGlobalPkgs = true;
          home-manager.useUserPackages = true;
        }
        (./modules)
        (./machines/finch)
      ];
    };

  };
}
