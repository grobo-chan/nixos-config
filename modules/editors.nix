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
  };

  environment.sessionVariables = {
    EDITOR = lib.getExe config.wrappers.helix.wrapper;
  };

  environment.systemPackages = with pkgs; [
    obsidian
  ];
}
