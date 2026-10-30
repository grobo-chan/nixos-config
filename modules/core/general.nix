{
  config,
  lib,
  hostName,
  ...
}: {
  imports =
    [
      ./hjem.nix
      ./fish.nix
      ./nix.nix
    ]
    ++ lib.optionals (hostName != "vm") [
      ./sops.nix
    ];

  users = {
    mutableUsers =
      if config.persistance.enable
      then false
      else true;
    users = {
      ${config.preferences.user.name} = {
        shell = config.wrappers.fish.wrapper;
        isNormalUser = true;
        description = config.preferences.user.description;
        extraGroups = ["networkmanager" "wheel"];
        initialPassword = "password";
      };

      root = {
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
    ".config/nixos"
    ".ssh"
  ];
}
