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
  zenPolicies,
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
    pname = "zen-browser-unwrapped";
    applicationName = "Zen Browser";

    src = sources.zen-browser;

    nativeBuildInputs = [
      wrapGAppsHook3
      autoPatchelfHook
      patchelfUnstable
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
      mkdir -p "$prefix/lib/zen-latest"
      cp -r * "$prefix/lib/zen-latest"

      mkdir -p $out/bin
      ln -s "$prefix/lib/zen-latest/zen" $out/bin/zen

      mkdir -p "$out/lib/zen-latest/distribution"
      ln -s ${policiesJson} "$out/lib/zen-latest/distribution/policies.json"
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
