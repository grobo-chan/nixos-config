{self, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.nix
      self.nixosModules.hjem
      self.nixosModules.sops
    ];

    sops.secrets.user_password.neededForUsers = true;
    users = {
      mutableUsers =
        if config.persistance.enable
        then false
        else true;
      users.${config.preferences.user.name} = {
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.user_password.path;
        initialPassword = "password";
        description = config.preferences.user.description;
        extraGroups = ["networkmanager" "wheel"];
      };
    };

    persistance.user.directories = [
      "nixos-config"
      "Videos"
      "Music"
      "Documents"
      "Projects"
      ".ssh"

      # TODO: Move
      ".local/share/zoxide"
      ".local/share/direnv"
      ".local/share/nvim"
      ".local/share/fish"
      ".config/nvim"
    ];
  };
}
