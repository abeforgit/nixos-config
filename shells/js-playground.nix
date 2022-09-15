{ pkgs, inputs }:
let
  node_package = pkgs.nodejs;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  name = "js-playground";
  root = ''"$PRJ_ROOT"'';
in pkgs.devshell.mkShell {
  inherit name;
  packages = with pkgs; [ google-chrome docker-compose ];
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
      name = "pnpm";
      help = "alternative package manager";
      package = pkgs.nodePackages.pnpm;
    }
    {
      name = "ember";
      help = "The ember cli";
      command = ''${ember} "$@"'';
    }
    # {
    #   name = "woodpecker-cli";
    #   help = "The Woodpecker cli";
    #   package = pkgs.woodpecker-cli;
    # }

  ];
}
