{
  description = "chiyonn home-manager config";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixvim = {
      url = "github:nix-community/nixvim";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { nixpkgs, home-manager, nixvim, ... }:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};
    in {
      homeConfigurations.chiyonn = home-manager.lib.homeManagerConfiguration {
        inherit pkgs;

        modules = [
          nixvim.homeManagerModules.nixvim
          ./home.nix
        ];

        extraSpecialArgs = { inherit nixvim; };
      };
    };
}
