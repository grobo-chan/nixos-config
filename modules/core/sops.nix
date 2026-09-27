{
  sources,
  config,
  ...
}: let
  homeDir =
    if config.persistance.enable
    then "/persistent/${config.hj.directory}"
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

  persistance.user.directories = [
    ".config/sops"
  ];
}
