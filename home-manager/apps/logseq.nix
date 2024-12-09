
{ pkgs, ... }: let
  pname = "logseq";
  version = "0.10.9";
  src = pkgs.fetchurl {
    url = "https://github.com/logseq/logseq/releases/download/0.10.9/Logseq-linux-x64-0.10.9.AppImage";
    hash = "sha256-XROuY2RlKnGvK1VNvzauHuLJiveXVKrIYPppoz8fCmc=";
  };
  appimageContents = pkgs.appimageTools.extract {inherit pname version src;};
in
  pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Create necessary directories
      mkdir -p $out/share/applications
      mkdir -p $out/share/icons/hicolor/512x512/apps

      # Create desktop file
      cat > $out/share/applications/logseq.desktop << EOF
      [Desktop Entry]
      Name=Logseq
      Exec=logseq
      Terminal=false
      Type=Application
      Icon=logseq
      StartupWMClass=Logseq
      Comment=A privacy-first, open-source platform for knowledge management and collaboration
      Categories=Office;
      EOF

      # Copy icon file (we'll use .DirIcon as fallback if the expected path doesn't exist)
      if [ -f ${appimageContents}/usr/share/icons/hicolor/512x512/apps/logseq.png ]; then
        install -m 444 ${appimageContents}/usr/share/icons/hicolor/512x512/apps/logseq.png \
          $out/share/icons/hicolor/512x512/apps/logseq.png
      elif [ -f ${appimageContents}/.DirIcon ]; then
        install -m 444 ${appimageContents}/.DirIcon \
          $out/share/icons/hicolor/512x512/apps/logseq.png
      fi
    '';

    extraPkgs = pkgs: with pkgs; [
      unzip
      autoPatchelfHook
      asar
      (buildPackages.wrapGAppsHook.override {inherit (buildPackages) makeWrapper;})
    ];
  }
