{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.europa = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      inputs.nix-minecraft.nixosModules.minecraft-servers
      self.nixosModules.hostEuropa
    ];
  };

  flake.nixosModules.hostEuropa = {pkgs, ...}: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop
      self.nixosModules.git
      self.nixosModules.editors

      # server stuff
      self.nixosModules.sshServer
      self.nixosModules.bootScript
      self.nixosModules.minecraftServer

      # disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostEuropa

      # preservation
      self.nixosModules.preservation
    ];

    persistance = {
      enable = true;
      nukeRoot.enable = true;
    };

    boot = {
      # silence first boot output
      consoleLogLevel = 3;
      initrd.verbose = false;
      initrd.systemd.enable = true;
      kernelParams = [
        "quiet"
        "splash"
        "intremap=on"
        "boot.shell_on_fail"
        "udev.log_priority=3"
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

    networking.hostName = "europa";
    networking.networkmanager.enable = true;

    services.printing.enable = true;
    services.udisks2.enable = true;
    hardware.enableRedistributableFirmware = true;

    services.logind.settings.Login.HandleLidSwitch = "ignore"; # Do nothing when Lid is closed

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
