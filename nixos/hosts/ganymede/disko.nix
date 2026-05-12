{
  flake.diskoConfigurations.hostGanymede = {
    fileSystems."/nix".neededForBoot = true;
    
    disko.devices.disk.main = {
      type = "disk";
      device = "/dev/disk/by-id/nvme-SKHynix_HFS001TEM4X182N_5ME9N008015109O63";
      content = {
        type = "gpt";
        partitions = {
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
              name = "crypted";
              passwordFile = "/tmp/secret.key";
              content = {
                type = "btrfs";
                extraArgs = ["-f"];
                
                subvolumes = {
                  "/root" = {
                     mountOptions = ["subvol=root" "noatime"];
                     mountpoint = "/";
                  };
                  "/persistent" = {
                     mountOptions = ["subvol=persistent" "noatime"];
                     mountpoint = "/persistent";
                  };
                  "/nix" = {
                    mountOptions = ["subvol=nix" "noatime"];
                    mountpoint = "/nix";
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
