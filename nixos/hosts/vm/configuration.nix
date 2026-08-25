{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.vm = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      self.nixosModules.hostVM
    ];
  };

  flake.nixosModules.hostVM = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.editors
      self.nixosModules.git

      # server stuff
      self.nixosModules.sshServer

      # disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostVM

      # preservation
      self.nixosModules.preservation
    ];

    persistance = {
      enable = true;
      nukeRoot = {
        enable = true;
        volumeGroup = "mapper/cryptroot";
      };
    };

    boot = {
      consoleLogLevel = 4;
      initrd.verbose = true;
      initrd.systemd.enable = true;
      kernelParams = [
        "splash"
        "intremap=on"
        "boot.shell_on_fail"
        "rd.systemd.show_status=auto"
      ];

      # plymouth, showing after LUKS unlock
      plymouth = {
        enable = true;
        font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
        logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
      };
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

    networking.hostName = "vm";
    networking.networkmanager.enable = true;

    services.udisks2.enable = true;
    hardware.enableRedistributableFirmware = true;

    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
