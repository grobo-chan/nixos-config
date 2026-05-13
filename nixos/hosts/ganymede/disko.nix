{
  flake.diskoConfigurations.hostGanymede = {
    fileSystems."/nix".neededForBoot = true;
    
    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEM4X182N_5ME9N008015109O63";
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
              mountOptions = [ "umask=0077" ];
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
                  "/nix" = {
                    mountOptions = ["subvol=nix" "compress=zstd" "noatime"];
                    mountpoint = "/nix";
                  };
                  "/persistent/swap" = {
                    mountpoint = "/persistent/swap";
                    mountOptions = ["subvol=swap" "noatime" "nodatacow" "compress=no"];
                    swap.swapfile.size = "18G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
