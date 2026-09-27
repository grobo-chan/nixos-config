{
  disko.devices.disk.main = {
    type = "disk";
    device = "/dev/disk/by-id/ata-Samsung_SSD_860_EVO_M.2_250GB_S5GFNG0M903341P";
    content = {
      type = "gpt";
      partitions = {
        boot = {
          name = "boot";
          size = "1M";
          type = "EF02";
        };

        ESP = {
          size = "512M";
          type = "EF00";
          content = {
            type = "filesystem";
            format = "vfat";
            mountpoint = "/boot";
            mountOptions = ["umask=0077"];
          };
        };

        luks = {
          size = "100%";
          content = {
            type = "luks";
            name = "cryptroot";
            settings.allowDiscards = true;
            passwordFile = "/persistent/secret.key";

            content = {
              type = "btrfs";
              extraArgs = ["-L" "nixos" "-f"];
              subvolumes = {
                "/root" = {
                  mountOptions = ["subvol=root" "compress=zstd" "noatime"];
                  mountpoint = "/";
                };
                "/persistent" = {
                  mountOptions = ["subvol=persistent" "compress=zstd" "noatime"];
                  mountpoint = "/persistent";
                };
                "/cache" = {
                  mountOptions = ["subvol=cache" "compress=zstd" "noatime"];
                  mountpoint = "/cache";
                };
                "/nix" = {
                  mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                  mountpoint = "/nix";
                };
                "/persistent/swap" = {
                  mountpoint = "/persistent/swap";
                  mountOptions = ["subvol=swap" "noatime" "nodatacow" "compress=no"];
                  swap.swapfile.size = "10G";
                };
              };
            };
          };
        };
      };
    };
  };
}
