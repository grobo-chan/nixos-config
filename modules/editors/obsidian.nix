{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    obsidian
  ];

  persistance.user = {
    directories = [
      ".config/obsidian"
    ];
  };
}
