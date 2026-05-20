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

  flake.nixosModules.hostCallisto = {pkgs, ...}: {
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

    programs.tmux.enable = true;

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
