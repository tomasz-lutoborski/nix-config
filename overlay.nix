self: super: {
  dbeaver = super.dbeaver.overrideAttrs (oldAttrs: {
    postInstall = ''
      substituteInPlace $out/share/applications/dbeaver.desktop \
        --replace "Exec=dbeaver" "Exec=GTK_THEME=Adwaita dbeaver"
    '';
  });
}
