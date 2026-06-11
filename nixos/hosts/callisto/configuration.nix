{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.callisto = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostCallisto
      inputs.nixos-hardware.nixosModules.raspberry-pi-4
    ];
  };

  flake.nixosModules.hostCallisto = {
    pkgs,
    config,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.sshServer
    ];

    persistance = {
      enable = false;
      nukeRoot.enable = false;
    };

    hardware = {
      enableRedistributableFirmware = true;
      raspberry-pi."4".apply-overlays-dtmerge.enable = true;
      deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
      };
    };

    /*
    To see the status of the timer run
    systemctl status nixos-upgrade.timer

    To see upgrade logs run
    systemctl status nixos-upgrade.service
    */
    system.autoUpgrade = {
      enable = true;
      flake = "${config.hj.directory}/nixos-config#${config.networking.hostName}";
      flags = [
        "--print-build-logs"
        "--commit-lock-file"
      ];
      dates = "12:00";
      randomizedDelaySec = "45min";
    };

    systemd.services.bootScript = {
      enable = true;
      description = "Custom Boot Script";
      after = ["network.target"];
      wantedBy = ["multi-user.target"];

      script = ''
        echo "Starting bootscript"
        ${pkgs.bash}/bin/bash ${config.hj.directory}/boot.sh
      '';
    };

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      vim
    ];

    networking.hostName = "callisto";
    networking.networkmanager.enable = true;
    networking.wireless.extraConfig = ''
      country=IN
    '';
    networking.networkmanager.wifi.powersave = false;

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
