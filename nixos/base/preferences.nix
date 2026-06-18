{
  flake.nixosModules.base = {lib, ...}: {
    options.preferences = {
      user = {
        name = lib.mkOption {
          type = lib.types.str;
          default = "grobo";
        };

        description = lib.mkOption {
          type = lib.types.str;
          default = "GroboChan";
        };
      };

      useLix = lib.mkEnableOption "Use Lix";
    };
  };
}
