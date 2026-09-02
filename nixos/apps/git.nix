{
  flake.nixosModules.git = {
    pkgs,
    lib,
    ...
  }: {
    programs.git = {
      enable = true;
      lfs.enable = true;

      config = {
        init = {
          defaultBranch = "main";
        };

        # needed for github authentication for private repos
        # adapted from home-manager:
        # https://github.com/nix-community/home-manager/blob/142acd7a7d9eb7f0bb647f053b4ddfd01fdfbf1d/modules/programs/gh.nix#L191
        credential =
          [
            "https://github.com"
            "https://gist.github.com"
          ]
          |> map (
            host:
              lib.nameValuePair host {
                helper = [
                  ""
                  "${lib.getExe pkgs.gh} auth git-credential"
                ];
              }
          )
          |> lib.listToAttrs;
      };
    };

    environment.systemPackages = [pkgs.gh];
  };
}
