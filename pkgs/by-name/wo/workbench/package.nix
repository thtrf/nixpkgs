{ 
  stdenv,
  lib,
  fetchgit,
  meson,
  glib,
  gjs,
  ninja,
  gtk4,
  gsettings-desktop-schemas,
  wrapGAppsHook4,
  desktop-file-utils,
  gobject-introspection,
  glib-networking,
  pkg-config,
  libadwaita,
  appstream,
  blueprint-compiler,
  gettext,
  libportal-gtk4,
  languagetool,
  fasttext,
  vala,
  rustc,
  cmake,
  gtksourceview5,
  libshumate,
  webkitgtk_6_0,
  vte-gtk4,
  bubblewrap,
  runtimeShell,
  nix-update-script,
}:

stdenv.mkDerivation (finalAttrs: {
  pname = "workbench";
  version = "47.1";

  src = fetchgit {
    url = "https://github.com/workbenchdev/workbench.git";
    tag = "v${finalAttrs.version}";
    hash = "sha256-0Xi6olQ57/2kunsM/gz8+40X88xGJ4YqjUarEUVbm74=";
    fetchSubmodules = true;
  };

  patches = [
    ./flatpak.patch
  ];

  nativeBuildInputs = [
    desktop-file-utils
    gobject-introspection
    meson
    ninja
    pkg-config
    wrapGAppsHook4
    appstream
    gjs
    libportal-gtk4
    vala
    rustc
    cmake
    blueprint-compiler
  ];

  buildInputs = [
    gettext
    gjs
    glib
    glib-networking
    gsettings-desktop-schemas
    gtk4
    libadwaita
    libportal-gtk4
    gtksourceview5
    libshumate
    webkitgtk_6_0
    vte-gtk4
  ];

  postPatch = ''
    substituteInPlace troll/gjspack/bin/gjspack --replace-fail "/usr/bin/env -S gjs" "${gjs}/bin/gjs"
    substituteInPlace src/meson.build --replace-fail "/app/bin/blueprint-compiler" "${blueprint-compiler}/bin/blueprint-compiler"
    sed -i "1 a imports.package._findEffectiveEntryPointName = () => 're.sonny.Workbench';" src/bin.js
    patchShebangs {,.}*
  '';

  # Add the sandbox wrapper in install phase
  postInstall = ''
    mv $out/bin/workbench $out/bin/workbench-real

    cat > $out/bin/workbench <<EOF
    #!${runtimeShell}
    exec ${bubblewrap}/bin/bwrap \
      --ro-bind /nix /nix \
      --ro-bind /etc/resolv.conf /etc/resolv.conf \
      --dev /dev \
      --proc /proc \
      --tmpfs /tmp \
      --unshare-all \
      --die-with-parent \
      -- \
      $out/bin/workbench-real "\$@"
    EOF

    chmod +x $out/bin/workbench
  '';

  strictDeps = true;

  passthru.updateScript = nix-update-script { };

  meta = {
    description = "Learn and prototype with GNOME technologies";
    homepage = "https://github.com/workbenchdev/workbench";
    license = lib.licenses.gpl3Only;
    maintainers = with lib.maintainers; [ thtrf ];
    mainProgram = "workbench";
    platforms = lib.platforms.linux;
  };
})
