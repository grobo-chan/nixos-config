{
  flake.diskoConfigurations = {
    hostGanymede = import ./ganymede/disko.nix;
    hostEuropa = import ./europa/disko.nix;
  };
}
