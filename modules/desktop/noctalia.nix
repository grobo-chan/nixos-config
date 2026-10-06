{
  sources,
  config,
  ...
}: {
  hjem.extraModules = [
    ((import sources.noctalia) {}).hjemModule
  ];

  hj.programs.noctalia = {
    enable = true;

    settings = {
      wallpaper = rec {
        enabled = true;
        directory = "${config.hj.directory}/Pictures/Wallpapers";
        default.path = "${directory}/default.jpg";
        automation = {
          enabled = true;
          interval_seconds = 1800;
          order = "random";
          recursive = true;
        };
      };
      backdrop = {
        enabled = true;
        blur_intensity = 0.5;
        tint_intensity = 0.3;
      };
      shell = {
        greeter_sync = {
          auto_sync = true;
          privilege_command = "kitty -e pkexec";
        };
      };
    };
  };
}
