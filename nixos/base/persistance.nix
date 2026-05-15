{
  flake.nixosModules.base = {
    lib,
    config,
    ...
  }: {
    options.persistance = {
      volumeGroup = lib.mkOption {
        default = "mapper/cryptroot";
        description = ''
          Btrfs volume group name
        '';
      };

      sys = {
        directories = lib.mkOption {
          default = [];
          description = ''
            system directories to persist
          '';
        };

        files = lib.mkOption {
          default = [];
          description = ''
            system files to persist
          '';
        };
      };

      user = {
        name = lib.mkOption {
          default = config.preferences.user.name;
          description = ''
            Main user
          '';
        };

        directories = lib.mkOption {
          default = [];
          description = ''
            user directories to persist
          '';
        };

        files = lib.mkOption {
          default = [];
          description = ''
            user files to persist
          '';
        };
      };
    };
  };
}
