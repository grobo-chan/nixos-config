{inputs, ...}: {
  flake.nixosModules.sops = {config, ...}: let
    homeDir =
      if config.persistance.enable
      then "/persistent${config.hj.directory}"
      else config.hj.directory;
  in {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = ../hosts/secrets.json;
      # workaround for https://github.com/Mic92/sops-nix/issues/604
      # yaml is a superset of json apparently
      defaultSopsFormat = "yaml";

      age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    };

    persistance.user.directories = [
      ".config/sops"
    ];
  };
}
