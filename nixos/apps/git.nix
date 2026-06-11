{
  flake.nixosModules.git = {
    config,
    lib,
    ...
  }: let
    user = config.preferences.user.name;
    gitProfiles = {
      default = "~/";
      alternate = "~/Projects/alternate/";
    };
  in {
    sops.secrets = builtins.listToAttrs (builtins.concatMap (
      name:
        lib.forEach ["name" "email" "key_path" "host"] (x: {
          name = "git/${name}/${x}";
          value = {owner = user;};
        })
    ) (builtins.attrNames gitProfiles));

    sops.templates = builtins.listToAttrs (builtins.concatMap (name: [
      {
        name = "git-config-${name}";
        value = {
          content = ''
            [user]
              name = "${config.sops.placeholder."git/${name}/name"}"
              email = "${config.sops.placeholder."git/${name}/email"}"
          '';
          owner = user;
        };
      }
      {
        name = "ssh-config-${name}";
        value = {
          content = ''
            Host ${name}.${config.sops.placeholder."git/${name}/host"}
              HostName ${config.sops.placeholder."git/${name}/host"}
              User git
              IdentityFile ${config.sops.placeholder."git/${name}/key_path"}
              IdentitiesOnly yes
          '';
          owner = user;
        };
      }
    ]) (builtins.attrNames gitProfiles));

    programs.git = {
      enable = true;
      lfs.enable = true;

      config =
        {
          init = {
            defaultBranch = "main";
          };
        }
        // builtins.listToAttrs (map (name: {
          name = "includeIf \"gitdir:${gitProfiles.${name}}\"";
          value = {path = config.sops.templates."git-config-${name}".path;};
        }) (builtins.attrNames gitProfiles));
    };

    programs.ssh.extraConfig = builtins.concatStringsSep "\n" (map (
      name: "Include ${config.sops.templates."ssh-config-${name}".path}"
    ) (builtins.attrNames gitProfiles));
  };
}
