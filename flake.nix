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
    nixosConfigurations.grobo-nixos = nixpkgs.lib.nixosSystem {
      specialArgs = {inherit inputs;};
      modules = [
        {
          nixpkgs = {
            inherit system;
            config.allowUnfree = true;

            overlays = [
              (final: prev: {
                alsa-ucm-conf = prev.alsa-ucm-conf.overrideAttrs (old: {
                  postInstall =
                    (old.postInstall or "")
                    + ''
                      echo "Patching ALSA UCM2 configs..."
                      mkdir -p $out/usr/share/alsa/ucm2/HDA
                      cp ${./hosts/grobo-nixos/ucm2/HiFi-analog.conf} $out/usr/share/alsa/ucm2/HDA/HiFi-analog.conf
                      cp ${./hosts/grobo-nixos/ucm2/HiFi-mic.conf} $out/usr/share/alsa/ucm2/HDA/HiFi-mic.conf
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
  };
}
