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

  outputs = {nixpkgs, ...} @ inputs: let
    system = "x86_64-linux";
  in {
    nixosConfigurations = {
      grobo-nixos = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {
            nixpkgs = {
              inherit system;
              config.allowUnfree = true;

              overlays = [
                (self: super: {
                  alsa-ucm-conf = super.alsa-ucm-conf.overrideAttrs (oldAttrs: {
                    postInstall =
                      (oldAttrs.postInstall or "")
                      + ''
                        # Copy the custom config files to the correct location in the package
                        cp ${./hosts/grobo-nixos/ucm2/HiFi-analog.conf} $out/share/alsa/ucm2/HDA/HiFi-analog.conf
                        cp ${./hosts/grobo-nixos/ucm2/HiFi-mic.conf} $out/share/alsa/ucm2/HDA/HiFi-mic.conf
                      '';
                  });
                })
              ];
            };
          }
          ./hosts/grobo-nixos/configuration.nix
          inputs.home-manager.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
        ];
      };

      television = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          {
            nixpkgs = {
              inherit system;
              config.allowUnfree = true;
            };
          }
          ./hosts/television/configuration.nix
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
