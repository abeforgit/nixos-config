{ pkgs, inputs }:
let name = "lisp";
in pkgs.devshell.mkShell {
  inherit name;

  packages = with pkgs; [ openssl ];
  commands = [
    {
      name = "sbcl";
      help = "lisp compiler";
      package = with pkgs; (sbcl.withPackages (ps: with ps; [ luckless cl_plus_ssl cl-mongo-id]));
    }
    {
      name = "quicklisp";
      help = "the lisp package manager";
      package = pkgs.lispPackages.quicklisp;
    }
  ];
}
