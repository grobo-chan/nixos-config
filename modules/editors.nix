{
  pkgs,
  nix-wrappers,
  lib,
  config,
  ...
}: {
  imports = [
    (nix-wrappers.lib.getInstallModule {
      name = "helix";
      value = nix-wrappers.lib.wrapperModules.helix;
    })
  ];

  wrappers.helix = {
    enable = true;

    settings = {
      theme = "amberwood";
      editor = {
        line-number = "relative";
        mouse = false;

        cursor-shape = {
          insert = "bar";
          normal = "block";
          select = "underline";
        };

        file-picker.hidden = false;
      };
    };

    languages = {
      language-server = {
        basedpyright = {
          command = "basedpyright-langserver";
          args = ["--stdio"];
          config.python.analysis.typeCheckingMode = "standard";
        };

        ruff = {
          command = "ruff";
          args = ["server"];
        };
      };

      language = [
        {
          name = "nix";
          auto-format = true;
          language-servers = ["nixd"];
          formatter = {
            command = "alejandra";
            args = ["-q" "-"];
          };
        }
        {
          name = "python";
          auto-format = true;
          language-servers = ["basedpyright" "ruff"];
        }
      ];
    };
  };

  environment.sessionVariables = {
    EDITOR = lib.getExe config.wrappers.helix.wrapper;
  };

  environment.systemPackages = with pkgs; [
    obsidian
    godot
    sqlitebrowser
  ];

  persistance.user = {
    directories = [
      ".config/obsidian"
      ".config/godot"
      ".local/share/godot"
    ];
    cache.directories = [
      ".cache/godot"
    ];
  };
}
