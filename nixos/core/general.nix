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

    users.users.${config.preferences.user.name} = {
      shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
      isNormalUser = true;
      description = config.preferences.user.description;
      initialPassword = "12345";
      extraGroups = ["networkmanager" "wheel" "video" "nopasswdlogin"];
    };
  };
}
