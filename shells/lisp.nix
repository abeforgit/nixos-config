{ pkgs, inputs }:
let name = "lisp";
in pkgs.devshell.mkShell {
  inherit name;

}
