{
  flake.nixosModules.sops = {...}: {
    persistance.user.directories = [
      ".config/sops"
    ];
  };
}
