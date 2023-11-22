{
  description = "Tomek's NixOS config";

  nixConfig = {
    experimental-features = [ "nix-command" "flakes" ];
    substituters = [
      # Replace the official cache with a mirror located in China
      "https://cache.nixos.org/"
    ];

    # extra-substituters = [
    #   # Nix community's cache server
    #   "https://nix-community.cachix.org"
    #   "https://lean4.cachix.org/"
    #   "https://cache.iog.io"
    # ];
    # extra-trusted-public-keys = [
    #   "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
    #   "hydra.iohk.io:f/Ea+s+dFdN+3Y/G+FDgSq+a5NEWhJGzdjvKNGv0/EQ="
    #   "lean4.cachix.org-1:mawtxSxcaiWE24xCXXgh3qnvlTkyU7evRRnGeAhD4Wk="
    # ];
  };

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Home manager
    home-manager.url = "github:nix-community/home-manager/master";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = { nixpkgs, home-manager, ... }@inputs: {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      nixos = nixpkgs.lib.nixosSystem {
        specialArgs = { inherit inputs; }; # Pass flake inputs to our config
        # > Our main nixos configuration file <
        modules = [ 
          ./nixos/configuration.nix
	  home-manager.nixosModules.home-manager
          {
            home-manager.useUserPackages = true;

            # home-manager.users.tomek = import ./home-manager/home.nix;
      	    home-manager.users.tomek = { pkgs, ... }: {
      	      imports = [
      	        ./home-manager/home.nix
      	      # Other imports
      	      ];
      	    };

            # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
            home-manager.extraSpecialArgs = { inherit inputs; }; # Pass flake inputs to our config
          } ];
      };
    };
  };
}
