{lib, ...}: {
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
  };
}
