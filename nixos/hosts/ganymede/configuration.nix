{
  inputs,
  self,
  ...
}: {
  flake.nixosConfigurations.ganymede = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.nixos-hardware.nixosModules.lenovo-legion-16iax10h
      inputs.disko.nixosModules.disko
      inputs.preservation.nixosModules.default
      self.nixosModules.hostGanymede
    ];
  };

  flake.nixosModules.hostGanymede = {
    pkgs,
    lib,
    ...
  }: {
    imports = [
      self.nixosModules.base
      self.nixosModules.general
      self.nixosModules.desktop

      self.nixosModules.gaming

      self.nixosModules.editors
      self.nixosModules.communication
      self.nixosModules.media
      self.nixosModules.creative

      self.nixosModules.kdeConnect

      # disko
      inputs.disko.nixosModules.disko
      self.diskoConfigurations.hostGanymede

      # preservation
      inputs.preservation.nixosModules.default
      self.nixosModules.preservation
    ];

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
      plymouth.enable = true;
      plymouth.font = "${pkgs.hack-font}/share/fonts/truetype/Hack-Regular.ttf";
      plymouth.logo = "${pkgs.nixos-icons}/share/icons/hicolor/128x128/apps/nix-snowflake.png";
    };

    boot.initrd.systemd.services.nukeRoot = {
      wantedBy = ["initrd.target"];
      after = ["systemd-hibernate-resume.service"];
      before = ["sysroot.mount"];
      serviceConfig.Type = "oneshot";
      script = ''
        mkdir /btrfs_tmp
        mount /dev/mapper/cryptroot /btrfs_tmp
        if [[ -e /btrfs_tmp/root ]]; then
            mkdir -p /btrfs_tmp/old_roots
            timestamp=$(date --date="@$(stat -c %Y /btrfs_tmp/root)" "+%Y-%m-%-d_%H:%M:%S")
            mv /btrfs_tmp/root "/btrfs_tmp/old_roots/$timestamp"
        fi

        delete_subvolume_recursively() {
            IFS=$'\n'
            for i in $(btrfs subvolume list -o "$1" | cut -f 9- -d ' '); do
                delete_subvolume_recursively "/btrfs_tmp/$i"
            done
            btrfs subvolume delete "$1"
        }

        for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +30); do
            delete_subvolume_recursively "$i"
        done

        btrfs subvolume create /btrfs_tmp/root
        umount /btrfs_tmp
      '';
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
