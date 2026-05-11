{inputs, ...}: {
  flake.nixosModules.extra_hjem = {...}: {
    imports = [
      inputs.hjem.nixosModules.default
    ];

    config = {
      hjem = {
        users.grobo = {
          enable = true;
          directory = "/home/grobo";
          user = "grobo";
        };

        clobberByDefault = true;
      };
    };
  };
}
