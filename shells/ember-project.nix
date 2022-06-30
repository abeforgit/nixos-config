{ port, name, pkgs, npm-global, node_package }:
let ember = "${npm-global}/bin/ember";
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
      command = ''${ember} "$@"'';
    }

  ];
}
