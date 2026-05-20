{inputs, ...}: {
  flake.nixosModules.hjem = {config, ...}: let
    user = config.preferences.user.name;
  in {
    imports = [
      inputs.hjem.nixosModules.default
      (inputs.nixpkgs.lib.mkAliasOptionModule [ "hj" ] [ "hjem" "users" user ])
    ];

    config = {
      hjem = {
        users.${user} = {
          enable = true;
          directory = "/home/${user}";
          inherit user;
        };

        clobberByDefault = true;
      };
    };
  };
}
