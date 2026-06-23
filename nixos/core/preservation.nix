{inputs, ...}: {
  flake.nixosModules.preservation = {
    lib,
    config,
    ...
  }: let
    cfg = config.persistance;
  in {
    imports = [
      inputs.preservation.nixosModules.default
    ];

    config = lib.mkIf cfg.enable {
      fileSystems."/nix".neededForBoot = true;
      fileSystems."/persistent".neededForBoot = true;
      boot.tmp.cleanOnBoot = lib.mkDefault true;

      preservation = {
        enable = true;

        preserveAt."/persistent" = {
          commonMountOptions = ["x-gvfs-hide"];
          directories =
            [
              "/etc/nixos"
              "/var/lib/bluetooth"
              {
                directory = "/var/lib/nixos";
                inInitrd = true;
              }
              {
                directory = "/var/lib/systemd/coredump";
                inInitrd = true;
              }
              {
                directory = "/etc/NetworkManager/system-connections";
                inInitrd = true;
              }
              {
                directory = "/tmp";
                mode = "0777";
              }
            ]
            ++ cfg.sys.directories;

          files =
            [
              # I left this here blank incase I wanna add something in the future™
            ]
            ++ cfg.sys.files;

          users.${cfg.user.name} = {
            directories = cfg.user.directories;
            files = cfg.user.files;
          };
        };
      };

      boot.initrd.systemd.services.nukeRoot = lib.mkIf cfg.nukeRoot.enable {
        wantedBy = ["initrd.target"];
        after = ["systemd-hibernate-resume.service"];
        before = ["sysroot.mount"];
        serviceConfig.Type = "oneshot";
        script = ''
          mkdir /btrfs_tmp
          mount /dev/${cfg.nukeRoot.volumeGroup} /btrfs_tmp
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

          for i in $(find /btrfs_tmp/old_roots/ -maxdepth 1 -mtime +10); do
              delete_subvolume_recursively "$i"
          done

          btrfs subvolume create /btrfs_tmp/root
          umount /btrfs_tmp
        '';
      };
    };
  };
}
