{
  flake.nixosModules.bootScript = {
    pkgs,
    config,
    ...
  }: {
    systemd.services.bootScript = {
      enable = true;
      description = "Custom Boot Script";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      script = ''
        echo "Starting bootscript"
        ${pkgs.bash}/bin/bash /home/${config.preferences.user.name}/boot/run.sh
      '';
    };

    persistance.user.directories = [
      "boot"
    ];
  };
}
