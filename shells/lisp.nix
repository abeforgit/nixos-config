{ pkgs, inputs }:
let name = "lisp";
in pkgs.devshell.mkShell {
  inherit name;

  commands = [
    {
      name = "sbcl";
      help = "lisp compiler";
      package = pkgs.sbcl;
    }
    {
      name = "quicklisp";
      help = "the lisp package manager";
      package = pkgs.lispPackages.quicklisp;
    }
  ];
}
