{
  nix-wrappers,
  config,
  lib,
  ...
}: {
  imports = [
    ./kitty.nix
    ./noctalia.nix
    (nix-wrappers.lib.getInstallModule {
      name = "niri";
      value = nix-wrappers.lib.wrapperModules.niri;
    })
  ];

  wrappers.niri = {
    enable = true;
    settings = {
      spawn-at-startup = [
        (lib.getExe config.wrappers.noctalia.wrapper)
      ];
      binds = {
        "Mod+T".spawn-sh = lib.getExe config.wrappers.kitty.wrapper;
      };
    };
  };

  programs.niri = {
    package = config.wrappers.niri.wrapper;
    enable = true;
  };
}
