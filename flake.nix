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
      	./machines/finch 
	home-manager.nixosModules.home-manager {
		home-manager.useGlobalPkgs = true;
		home-manager.useUserPackages = true;
		home-manager.users.arne = import ./machines/finch/home.nix;
	}
	];
    };

  };
}
