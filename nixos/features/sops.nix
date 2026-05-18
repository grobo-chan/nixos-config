{inputs, ...}: {
  flake.nixosModules.sops = {config, pkgs, ...}: {
    imports = [
      inputs.sops-nix.nixosModules.sops
    ];

    sops = {
      defaultSopsFile = ../hosts/secrets.json;
      defaultSopsFormat = "json";

      age.keyFile = "${config.hj.directory}/.config/sops/age/keys.txt";
    };

    persistance.user.directories = [
      ".config/sops"
    ];
  };
}
