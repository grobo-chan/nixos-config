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

  flake.nixosModules.hostGanymede = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.general
      self.nixosModules.gaming

      self.nixosModules.editors
      self.nixosModules.communication
      self.nixosModules.media
      self.nixosModules.creative

      self.nixosModules.kdeConnect
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

    hardware.nvidia.prime = {
      offload = {
        enable = true;
        enableOffloadCmd = true;
      };
    };

    specialisation = {
      gaming-time.configuration = {
        hardware.nvidia.prime = {
          sync.enable = true;

          offload = {
            enable = lib.mkForce false;
            enableOffloadCmd = lib.mkForce false;
          };
        };
      };
    };

    services.udisks2.enable = true;

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
