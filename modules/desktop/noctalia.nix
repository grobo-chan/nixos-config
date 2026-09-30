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
      wallpaper = {
        enabled = true;
        directory = "${config.hj.directory}/Pictures/Wallpapers";
      };
      backdrop = {
        enabled = true;
        blur_intensity = 0.5;
        tint_intensity = 0.3;
      };
      shell = {
        greeter_sync = {
          auto_sync = true;
        };
      };
    };
  };
}
