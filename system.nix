let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
  };
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";
in {
  vm = nixosSystem {
    inherit pkgs;
    specialArgs = {
      inherit sources;
    };

    modules = [
      ./hosts/vm/configuration.nix
    ];
  };
}
