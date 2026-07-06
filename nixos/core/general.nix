{self, inputs, ...}: {
  flake.nixosModules.general = {
    pkgs,
    config,
    lib,
    ...
  }: let
    user = config.preferences.user.name;
  in {
    imports = [
      self.nixosModules.nix
      self.nixosModules.hm
      self.nixosModules.sops
      (inputs.nixpkgs.lib.mkAliasOptionModule ["home"] ["users" "users" user "home"])
    ];

    sops.secrets.user_password.neededForUsers = true;
    sops.secrets.guest_password.neededForUsers = true;
    users = {
      mutableUsers =
        if config.persistance.enable
        then false
        else true;
      users = {
        ${user} = {
          # shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
          shell = pkgs.fish;
          isNormalUser = true;
          hashedPasswordFile = config.sops.secrets.user_password.path;
          initialPassword = "password";
          description = config.preferences.user.description;
          extraGroups = ["networkmanager" "wheel"];
        };

        # TODO: Re-add guest user later
        # guest = lib.mkIf config.preferences.enableGuest {
        #   shell = self.packages.${pkgs.stdenv.hostPlatform.system}.environment;
        #   isNormalUser = true;
        #   hashedPasswordFile = config.sops.secrets.guest_password.path;
        #   initialPassword = "password";
        #   description = "Guest User";
        # };
      };
    };

    programs.fish.enable = true;

    home-manager.users.${user} = self.homeModules.mainUserModule;

    persistance.user.directories = [
      "nixos-config"
      "Videos"
      "Music"
      "Pictures"
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
