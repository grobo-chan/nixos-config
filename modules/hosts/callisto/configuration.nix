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
      self.nixosModules.general
      self.nixosModules.sshServer
    ];

    hardware = {
      raspberry-pi."4".apply-overlays-dtmerge.enable = true;
      deviceTree = {
        enable = true;
        filter = "*rpi-4-*.dtb";
      };
    };
    console.enable = false;

    environment.systemPackages = with pkgs; [
      libraspberrypi
      raspberrypi-eeprom
      vim
    ];

    networking.hostName = "callisto";
    networking.networkmanager.enable = true;

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
