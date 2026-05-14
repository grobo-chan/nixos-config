{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.hjem
    ];

    users.users.grobo = {
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
      isNormalUser = true;
      description = "GroboChan";
      initialPassword = "12345";
      extraGroups = ["networkmanager" "wheel" "video" "nopasswdlogin"];
    };
  };
}
