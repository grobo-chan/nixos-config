{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.ganymede = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostGanymede
    ];
  };

  flake.nixosModules.hostGanymede = {pkgs, ...}: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.general
      self.nixosModules.gaming
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

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
