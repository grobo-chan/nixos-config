{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.europa = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostEuropa
    ];
  };

  flake.nixosModules.hostEuropa = {...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop
      self.nixosModules.sshServer
      self.nixosModules.editors
    ];

    persistance = {
      enable = false;
      nukeRoot.enable = false;
    };

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

    networking.hostName = "europa";
    networking.networkmanager.enable = true;

    services.printing.enable = true;

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
