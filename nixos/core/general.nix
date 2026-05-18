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

    sops.secrets.up.neededForUsers = true;
    users = {
      mutableUsers = false;
      users.${config.preferences.user.name} = {
        shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
        isNormalUser = true;
        hashedPasswordFile = config.sops.secrets.up.path;
        description = config.preferences.user.description;
        initialPassword = "12345";
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
      ".config/gh"
      ".local/state/gh"
    ];
  };
}
