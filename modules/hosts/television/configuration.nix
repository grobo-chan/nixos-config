{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.television = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      self.nixosModules.hostTV
    ];
  };

  flake.nixosModules.hostTV = {pkgs, ...}: {
    imports = [
      self.nixosModules.desktop
      self.nixosModules.general
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

    networking.hostName = "television";
    networking.networkmanager.enable = true;

    services.printing.enable = true;

    environment.systemPackages = with pkgs; [
      vim
      tor-browser
      vlc
      keepassxc
      zed-editor
    ];

    system.stateVersion = "25.11"; # DO NOT EDIT
  };
}
