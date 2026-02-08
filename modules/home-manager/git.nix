{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.git;
in {
  options.git = {
    enable = lib.mkEnableOption "enable git module";

    userName = lib.mkOption {
      default = "mainuser";
    };
    userEmail = lib.mkOption {
      default = "info@example.com";
    };
  };

  config = lib.mkIf cfg.enable {
    programs.git = {
      enable = true;
      settings = {
        user = {
          name = cfg.userName;
          email = cfg.userEmail;
        };
        init.defaultBranch = "main";
      };
      lfs.enable = true;
    };

    programs.gh = {
      enable = true;
      gitCredentialHelper.enable = true;
    };
  };
}
