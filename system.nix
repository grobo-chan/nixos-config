let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
  };
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  nix-wrappers = (import sources.wrappers) {inherit pkgs;};
in {
  vm = nixosSystem {
    inherit pkgs;
    specialArgs = {
      inherit sources nix-wrappers;
    };

    modules = [
      ./hosts/vm/configuration.nix
    ];
  };
}
