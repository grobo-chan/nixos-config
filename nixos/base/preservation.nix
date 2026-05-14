{
  flake.nixosModules.preservation = {pkgs, ...}: {
    preservation = {
      enable = true;

      preserveAt."/persistent" = {
        directories = [
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
            directory="/tmp";
            mode="0777";
          }
        ];

        files = [
          {
            file = "/etc/machine-id";
            inInitrd = true;
          }
        ];
      };
    };
  };
}
