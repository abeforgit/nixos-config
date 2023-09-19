{ pkgs, inputs }:
let
  pnpm = pkgs.nodePackages.pnpm;
  yalc = pkgs.nodePackages.yalc;
  node_package = pkgs.nodejs-18_x;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  name = "gn-meta";
  root = ''"$PRJ_ROOT"'';
in pkgs.devshell.mkShell {
  inherit name;
  env = [
    {
      name = "NPM_CONFIG_PREFIX";
      value = npm-global;
    }
    {
      name = "PATH";
      prefix = "${npm-global}/bin";
    }
    {
      name = "WOODPECKER_SERVER";
      value = "https://build.redpencil.io";
    }
  ];
  commands = [
    {
      name = "npm";
      help = "The node package manager";
      package = node_package;
    }
    {
      name = "pnpm";
      help = "A better node package manager";
      package = pnpm;
    }
    {
      name = "yalc";
      help = "a way to link npm packages";
      package = yalc;
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
    # {
    #   name = "woodpecker-cli";
    #   help = "The Woodpecker cli";
    #   package = pkgs.woodpecker-cli;
    # }

  ];
}
