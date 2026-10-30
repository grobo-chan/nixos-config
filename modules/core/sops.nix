{
  sources,
  config,
  ...
}: let
  homeDir =
    if config.persistance.enable
    then "/persistent${config.hj.directory}"
    else "${config.hj.directory}";
  ageKeyPath = "${homeDir}/.config/sops/age/keys.txt";
in {
  imports = ["${sources.sops-nix}/modules/sops"];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = ageKeyPath;
    age.sshKeyPaths = [];
  };

  sops.secrets.user_password.neededForUsers = true;
  sops.secrets.root_password.neededForUsers = true;

  users.users = {
    ${config.preferences.user.name}.hashedPasswordFile = config.sops.secrets.user_password.path;
    root.hashedPasswordFile = config.sops.secrets.root_password.path;
  };

  persistance.user.directories = [
    ".config/sops"
  ];
}
