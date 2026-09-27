let
  sources = import ./npins;
  pkgs = import sources.nixpkgs {
    config.allowUnfree = true;
  };
  nixosSystem = import "${sources.nixpkgs}/nixos/lib/eval-config.nix";

  nix-wrappers = (import sources.wrappers) {inherit pkgs;};

  hosts =
    ./hosts
    |> builtins.readDir
    |> pkgs.lib.filterAttrs (name: type: type == "directory")
    |> pkgs.lib.attrNames;
in
  pkgs.lib.genAttrs hosts (name:
    nixosSystem {
      inherit pkgs;
      specialArgs = {
        inherit sources nix-wrappers;
      };

      modules = [
        ./hosts/${name}/configuration.nix
      ];
    })
