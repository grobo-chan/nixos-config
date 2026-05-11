{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.extra_hjem
    ];

    users.users.grobo = {
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
      isNormalUser = true;
      description = "GroboChan";
      extraGroups = ["networkmanager" "wheel" "video"];
    };
  };
}
