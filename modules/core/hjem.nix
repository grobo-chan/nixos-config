{
  pkgs,
  sources,
  config,
  lib,
  ...
}: let
  hjemSrc = (import sources.hjem) {inherit pkgs;};
  user = config.preferences.user.name;
in {
  imports = [
    hjemSrc.nixosModules.default
    (lib.mkAliasOptionModule ["hj"] ["hjem" "users" user])
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
}
