{inputs, ...}: {
  flake.nixosModules.hjem = {...}: {
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
