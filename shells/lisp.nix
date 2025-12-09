{ pkgs, inputs }:
let
  name = "lisp";
in
pkgs.devshell.mkShell {
  inherit name;


  packages = with pkgs; [
    coreutils
    curl
    openssl
    gcc
    libfixposix
    gnumake
  ];
  packagesFrom = with pkgs; [
    libfixposix
  ];
  commands = [
    {
      name = "sbcl";
      help = "lisp compiler";
      package =
        with pkgs;
        (sbcl.withPackages (
          ps: with ps; [
            luckless
            cl_plus_ssl
            cl-mongo-id
          ]
        ));
    }
  ];
}
