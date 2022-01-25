{ stdenv, lib, fetchurl, glibc, zlib, autoPatchelfHook, glib, libXxf86vm
, libXtst, libcef, fontconfig, dejavu_fonts, freetype, libXrender, libXfont
, font-manager, roboto, libX11, libXext, libXrandr, cups, alsa-lib, libXt }:
stdenv.mkDerivation rec {
  name = "jetbrains-jre-jcef-${version}";

  version = "11_0_13-linux-x64-b1890.3";
  src = fetchurl {
    url =
      "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_jcef-${version}.tar.gz";
    hash =
      "sha512:XTbTbMhlR+aLlYlmBK69SSRPHzXuAAUacbYNw7RzxB3M+uTppCkdj011J0bcdl9veGhhM8lEPjAUCzRxy4P1FQ==";
  };
  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
  ];

  # Required at running time
  buildInputs = [
    glibc
    zlib
    libXxf86vm
    libXtst
    libcef
    fontconfig
    dejavu_fonts
    freetype
    libXrender
    libXfont
    font-manager
    roboto
    libX11
    libXext
    libXrandr
    libXt
    cups
    alsa-lib
  ];

  # Extract and copy executable in $out/bin
  installPhase = ''
    mkdir -p $out
    cp -ia . $out
  '';

  meta = with lib; {
    description = "jetbrains jcef jre";
    platforms = platforms.linux;
  };
}
