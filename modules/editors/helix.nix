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

        typescript-language-server = {
          command = "typescript-language-server";
          args = ["--stdio"];
          required-root-patterns = ["package.json"];
          config.plugins = [
            {
              name = "@vue/typescript-plugin";
              location = "./node_modules/@vue/typescript-plugin";
              languages = ["vue"];
            }
          ];
        };

        vue-language-server = {
          command = "vue-language-server";
          args = ["--stdio"];
        };

        emmet-lsp = {
          command = "emmet-language-server";
          args = ["--stdio"];
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
          language-servers = ["typescript-language-server"];
          formatter = {
            command = "prettier";
            args = ["--parser" "typescript"];
          };
        }
        {
          name = "javascript";
          auto-format = true;
          language-servers = ["typescript-language-server"];
          formatter = {
            command = "prettier";
            args = ["--parser" "javascript"];
          };
        }
        {
          name = "vue";
          auto-format = true;
          language-servers = ["vue-language-server" "typescript-language-server" "emmet-lsp"];
          formatter = {
            command = "prettier";
            args = ["--parser" "vue"];
          };
        }
        {
          name = "html";
          auto-format = true;
          language-servers = ["vscode-html-language-server" "emmet-lsp"];
          formatter = {
            command = "prettier";
            args = ["--parser" "html"];
          };
        }
        {
          name = "css";
          auto-format = true;
          language-servers = ["vscode-css-language-server" "emmet-lsp"];
          formatter = {
            command = "prettier";
            args = ["--parser" "css"];
          };
        }
      ];
    };
  };

  environment.sessionVariables = {
    EDITOR = lib.getExe config.wrappers.helix.wrapper;
  };
}
