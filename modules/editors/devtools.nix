{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    godot
    sqlitebrowser
    insomnia
  ];

  persistance.user = {
    directories = [
      ".config/godot"
      ".config/Insomnia"
      ".local/share/godot"
    ];
    cache.directories = [
      ".cache/godot"
    ];
  };
}
