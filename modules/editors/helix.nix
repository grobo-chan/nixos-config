{
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
        auto-format = true;
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
          language-servers = ["nixd"];
          formatter = {
            command = "alejandra";
            args = ["-q" "-"];
          };
          auto-format = true;
        }
        {
          name = "python";
          language-servers = ["basedpyright" "ruff"];
          auto-format = true;
        }
        {
          name = "typescript";
          auto-format = true;
        }
        {
          name = "javascript";
          auto-format = true;
        }
      ];
    };
  };

  environment.sessionVariables = {
    EDITOR = lib.getExe config.wrappers.helix.wrapper;
  };
}
