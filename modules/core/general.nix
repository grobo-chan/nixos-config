{
  pkgs,
  config,
  ...
}: {
  imports = [
    ./nix.nix
    ./sops.nix
  ];

  sops.secrets.user_password.neededForUsers = true;
  sops.secrets.root_password.neededForUsers = true;

  programs.fish.enable = true;
  users = {
    mutableUsers =
      if config.persistance.enable
      then false
      else true;
    users = {
      ${config.preferences.user.name} = {
        shell = pkgs.fish;
        isNormalUser = true;
        description = config.preferences.user.description;
        extraGroups = ["networkmanager" "wheel"];
        hashedPasswordFile = config.sops.secrets.user_password.path;
        initialPassword = "password";
      };

      root = {
        hashedPasswordFile = config.sops.secrets.root_password.path;
        initialPassword = "password";
      };
    };
  };

  persistance.user.directories = [
    "Videos"
    "Music"
    "Pictures"
    "Documents"
    "Projects"
    ".ssh"

    # TODO: Move
    ".local/share/zoxide"
    ".local/share/direnv"
    ".local/share/fish"
  ];
}
