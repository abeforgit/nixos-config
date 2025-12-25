{ pkgs, inputs }:
let
  name = "sparql-parser";
in
pkgs.devshell.mkShell {
  inherit name;

  commands = [
    {
      name = "sbcl";
      help = "lisp compiler";
      package =
        with pkgs;
        (sbcl.withPackages (
          ps: with ps; [
            alexandria
            cl-ppcre
            bordeaux-threads
            woo
            dexador
            jsown
            luckless
            sha1
            trivial-backtrace
            flexi-streams
          ]
        ));
    }
  ];
}
