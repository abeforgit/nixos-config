{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-16_x;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  port = 4500;
  name = "reglementaire-bijlage";
in {
  inherit name;
  packages = with pkgs; [ google-chrome ];
  env = [
    {
      name = "NPM_CONFIG_PREFIX";
      value = npm-global;
    }
    {
      name = "PATH";
      prefix = "${npm-global}/bin";
    }
  ];
  commands = [
    {
      name = "up-backend";
      help = "Start the development backend";
      command = "";
    }
    {
      name = "up-frontend";
      help = "Start the development server";
      command = "${ember} s --port=${port}";
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
      command = ''${ember} "$@"'';
    }

  ];
}
