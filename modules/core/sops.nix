{
  sources,
  config,
  lib,
  ...
}: let
  homeDir =
    if config.persistance.enable
    then "/persistent/home/${config.preferences.user.name}"
    else "/home/${config.preferences.user.name}";
  ageKeyPath = "${homeDir}/.config/sops/age/keys.txt";
in {
  imports = ["${sources.sops-nix}/modules/sops"];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = ageKeyPath;
    age.sshKeyPaths = [];
  };

  persistance.user.directories = [
    ".config/sops"
  ];
}
