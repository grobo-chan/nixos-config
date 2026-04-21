{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.ganymede = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostGanymede
      inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
    ];
  };

  flake.nixosModules.hostGanymede = {pkgs, ...}: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.general
      self.nixosModules.gaming

      self.nixosModules.editors
      self.nixosModules.communication
      self.nixosModules.media
      self.nixosModules.editing
    ];

    boot.loader.systemd-boot.enable = false;
    boot.loader.grub = {
      enable = true;
      devices = ["nodev"];
      useOSProber = true;
      efiSupport = true;

      extraEntries = ''
        menuentry "Reboot" {
          reboot
        }
        menuentry "Poweroff" {
          halt
        }
      '';
    };
    boot.loader.efi.canTouchEfiVariables = true;
    boot.loader.efi.efiSysMountPoint = "/boot";

    networking.hostName = "ganymede";
    networking.networkmanager.enable = true;

    services.printing.enable = true;
    services.power-profiles-daemon.enable = true;
    services.upower.enable = true;

    services.udisks2.enable = true;
    xdg.mime.addedAssociations = {
      "inode/directory" = "org.kde.dolphin.desktop";
    };

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
