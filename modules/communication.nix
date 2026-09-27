{
  sources,
  pkgs,
  ...
}: {
  environment.systemPackages = with pkgs; [
    (deltachat-desktop.overrideAttrs {
      patches = [
        (sources."delta-no-override-tilde.patch" {inherit pkgs;})
        (sources."delta-override-name.patch" {inherit pkgs;})
      ];
    })
    vesktop
    thunderbird
  ];

  persistance.user.directories = [
    ".config/vesktop"
    ".config/DeltaChat"
    ".config/thunderbird"
  ];

  persistance.user.cache.directories = [
    ".cache/thunderbird"
  ];
}
