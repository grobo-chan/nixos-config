{
  lib,
  config,
  pkgs,
  ...
}: let
  cfg = config.git;
in {
  options.zed = {
    enable = lib.mkEnableOption "enable git module";
  };

  config = lib.mkIf cfg.enable {
    programs.zed-editor = {
      enable = true;
      extensions = ["nix" "toml" "rust"];
      userSettings = {
        theme = {
          mode = "system";
          dark = "One Dark";
          light = "One Light";
        };
        hour_format = "hour24";
        vim_mode = true;
        languages = {
          Nix = {
            language_servers = ["nixd" "!nil"];
            formatter = {
              external = {
                command = "alejandra";
                arguments = ["--quiet" "--"];
              };
            };
          };
        };
      };
    };

    home.packages = with pkgs; [
      alejandra
      nixd
    ];
  };
}
