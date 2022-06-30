{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-14_x;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
in pkgs.devshell.mkShell (import ./ember-project.nix {
  inherit node_package npm-global pkgs;
  name = "ember-rdfa-editor";
  port = 4200;
}) // { }
