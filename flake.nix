{
  description = "Grobo's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
  };

  outputs = { nixpkgs, ... } @ inputs:
  let
    system = "x86_64-linux";
  in
  {

    nixosConfigurations.grobo-nixos = nixpkgs.lib.nixosSystem {
      specialArgs = { inherit inputs; };
      modules = [
        { nixpkgs = { inherit system; config.allowUnfree = true; }; }
        ./hosts/grobo-nixos/configuration.nix
        inputs.home-manager.nixosModules.default
        inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
      ];      
    };

  };
}
