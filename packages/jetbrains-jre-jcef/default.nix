{ stdenv, lib, fetchurl, glibc, zlib, autoPatchelfHook, glib, libXxf86vm
, libXtst, libcef }:
stdenv.mkDerivation rec {
  name = "jetbrains-jre-jcef-${version}";

  version = "11_0_12";
  src = fetchurl {
    url =
      "https://cache-redirector.jetbrains.com/intellij-jbr/jbr_dcevm-11_0_13-linux-x64-b1890.3.tar.gz";
    hash = "sha512:PRTuyuI6EH82zv/94hX7gf75fBOicFRZ721Rzy4dGQdYuLlraqWii4Kir0X5v7dGGo235PbmIujh3mVllrMUWg==";
  };
  # Required for compilation
  nativeBuildInputs = [
    autoPatchelfHook # Automatically setup the loader, and do the magic
  ];

  # Required at running time
  buildInputs = [ glibc zlib libXxf86vm libXtst libcef ];

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
