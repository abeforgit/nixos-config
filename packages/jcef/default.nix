with import <nixpkgs> { };

let
  my-python-packages = python-packages: with python-packages; [ ];
  python-with-my-packages = python37.withPackages my-python-packages;
in stdenv.mkDerivation rec {
  pname = "jetbrains-jcef";
  version = "7537870782a5035ae8e60d07f90d0c6a1df031db";

  src = fetchFromGitHub {
    owner = "JetBrains";
    repo = "jcef";
    rev = version;
    sha256 = "sha256-X6/cdHoRduh9M13JTw52avWNYB3XrTTsiMQU1SJS+Jk=";
    leaveDotGit = true;
  };

  nativeBuildInputs = [ cmake clang clang-tools jdk11 python-with-my-packages git gtk3 libcef ];

  buildInputs = [ libcef kitty ];
  configurePhase = ''
mkdir jcef_build && cd jcef_build
CMAKE_LIBRARY_PATH=${libcef.outPath}/lib cmake -G "Unix Makefiles" -DCMAKE_BUILD_TYPE=Release ..

'';

  # We don't want to download CEF; instead use our own.

  meta = with lib; {
    description = "JCEF";
    longDescription = ''
      JetBrains version of JCEF.
    '';
    license = licenses.gpl2;
    maintainers = [ ];
    platforms = with platforms; [ "x86_64-linux" ];
  };
}
