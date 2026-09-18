{
  sources,
  config,
  ...
}: let
  homeDir =
    if config.persistance.enable
    then "/persistent/home/${config.preferences.user.name}"
    else "/home/${config.preferences.user.name}";
in {
  imports = ["${sources.sops-nix}/modules/sops"];

  sops = {
    defaultSopsFile = ../../secrets.yaml;
    defaultSopsFormat = "yaml";

    age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
  };

  persistance.user.directories = [
    ".config/sops"
  ];
}
