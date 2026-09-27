# Adapted from: https://github.com/youwen5/zen-browser-flake/blob/master/zen-browser-unwrapped.nix
{
  sources,
  stdenv,
  wrapGAppsHook3,
  autoPatchelfHook,
  patchelfUnstable,
  adwaita-icon-theme,
  dbus-glib,
  libXtst,
  curl,
  gtk3,
  alsa-lib,
  libva,
  pciutils,
  pipewire,
  writeText,
  makeDesktopItem,
  copyDesktopItems,
  zenPolicies ? {},
  ...
}: let
  policies =
    {
      DisableAppUpdate = true;
    }
    // zenPolicies;

  policiesJson = writeText "firefox-policies.json" (builtins.toJSON {inherit policies;});
in
  stdenv.mkDerivation (finalAttrs: {
    version = "latest";
    pname = "zen-browser";
    applicationName = "Zen Browser";

    src = sources.zen-browser;

    nativeBuildInputs = [
      wrapGAppsHook3
      autoPatchelfHook
      patchelfUnstable
      copyDesktopItems
    ];

    desktopItems = [
      (makeDesktopItem {
        name = "zen";
        desktopName = "Zen Browser";
        exec = "zen %u";
        icon = "zen";
        comment = "A fast, private and secure web browser built to improve your day-to-day experience.";
        categories = ["Network" "WebBrowser"];
      })
    ];

    buildInputs = [
      gtk3
      alsa-lib
      adwaita-icon-theme
      dbus-glib
      libXtst
    ];

    runtimeDependencies = [
      curl
      libva.out
      pciutils
    ];

    appendRunpaths = [
      "${pipewire}/lib"
    ];

    installPhase = ''
      runHook preInstall

      mkdir -p "$prefix/lib/zen-latest"
      cp -r * "$prefix/lib/zen-latest"

      mkdir -p $out/bin
      ln -s "$prefix/lib/zen-latest/zen" $out/bin/zen

      mkdir -p "$out/lib/zen-latest/distribution"
      ln -s ${policiesJson} "$out/lib/zen-latest/distribution/policies.json"

      mkdir -p $out/share/icons/hicolor/128x128/apps
      mkdir -p $out/share/icons/hicolor/64x64/apps
      mkdir -p $out/share/icons/hicolor/48x48/apps
      mkdir -p $out/share/icons/hicolor/32x32/apps
      mkdir -p $out/share/icons/hicolor/16x16/apps
      cp $prefix/lib/zen-latest/browser/chrome/icons/default/default128.png $out/share/icons/hicolor/128x128/apps/zen.png
      cp $prefix/lib/zen-latest/browser/chrome/icons/default/default64.png $out/share/icons/hicolor/64x64/apps/zen.png
      cp $prefix/lib/zen-latest/browser/chrome/icons/default/default48.png $out/share/icons/hicolor/48x48/apps/zen.png
      cp $prefix/lib/zen-latest/browser/chrome/icons/default/default32.png $out/share/icons/hicolor/32x32/apps/zen.png
      cp $prefix/lib/zen-latest/browser/chrome/icons/default/default16.png $out/share/icons/hicolor/16x16/apps/zen.png

      runHook postInstall
    '';

    patchelfFlags = ["--no-clobber-old-sections"];

    meta = {
      mainProgram = "zen";
      description = ''
        Zen is a privacy-focused browser that blocks trackers, ads, and other unwanted content while offering the best browsing experience!
      '';
    };

    passthru = {
      inherit gtk3;

      libName = "zen-latest";
      binaryName = finalAttrs.meta.mainProgram;
      gssSupport = true;
      ffmpegSupport = true;
    };
  })
