{
  description = "NixOS Configurattion";
  inputs = {
	  nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
	  home-manager = {
	  	url = "github:nix-community/home-manager/master";
		inputs.nixpkgs.follows = "nixpkgs";
	  };
  };

  outputs = { self, nixpkgs, home-manager }: {

    nixosConfigurations.finch = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      modules = [ 
	home-manager.nixosModules.home-manager {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
	}
	(./modules)
      	./machines/finch 
	];
    };

  };
}
