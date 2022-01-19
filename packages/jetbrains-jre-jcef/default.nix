{ stdenv, lib, fetchurl, glibc, zlib, autoPatchelfHook, glib, libXxf86vm
, libXtst, libcef }:
stdenv.mkDerivation rec {
  name = "jetbrains-jre-jcef-${version}";

  version = "11_0_12";
  src = /. + "/home/arne/.jbr/jbr_jcef-${version}-linux-x64-b1649.1";
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
