{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-16_x;
  npm-global = toString ~/.npm-installs/node16;
  ember = "${npm-global}/bin/ember";
in pkgs.devshell.mkShell {
  name = "rdfa-editor";
  packages = with pkgs; [ google-chrome ];
  env = [
    {
      name = "NPM_CONFIG_PREFIX";
      value = npm-global;
    }
    {
      name = "PATH";
      prefix = npm-global;
    }
  ];
  commands = [
    {
      name = "rundev";
      help = "Start the development server";
      command = "${ember} s --port=4202";
    }
    {
      name = "npm";
      help = "The node package manager";
      package = node_package;
    }
    {
      name = "node";
      help = "Nodejs";
      package = node_package;
    }
    {
      name = "ember";
      help = "The ember cli";
      command = "${ember}";
    }

  ];
}
