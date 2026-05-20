{inputs, ...}: {
  flake.nixosModules.sops = {config, ...}: let
    homeDir = if config.persistance.enable then "/persistent${config.hj.directory}" else config.hj.directory;
  in {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = ../hosts/secrets.json;
      defaultSopsFormat = "json";

      age.keyFile = "${homeDir}/.config/sops/age/keys.txt";
    };

    persistance.user.directories = [
      ".config/sops"
    ];
  };
}
