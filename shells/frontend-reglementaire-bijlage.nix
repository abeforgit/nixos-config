{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-16_x;
  npm-global = toString ~/.npm-global;
in pkgs.devshell.mkShell (import ./ember-project.nix {
  inherit node_package npm-global pkgs;
  name = "frontend-reglementaire-bijlage";
  port = "4500";
}) // {

}
