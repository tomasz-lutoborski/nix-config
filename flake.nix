{
  description = "Tomek's NixOS config";

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

            home-manager.backupFileExtension = "bck";
          }
        ];
      };
    };
  };
}
