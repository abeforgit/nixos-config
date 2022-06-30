{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-16_x;
  npm-global = toString ~/.npm-installs/node16;
in pkgs.devshell.mkShell (import ./ember-project.nix {
  inherit node_package npm-global pkgs;
  name = "roadsign-regulations-plugin";
  port = 4202;
}) // {

}
