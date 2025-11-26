{ pkgs, inputs }:
let
  # node_package = pkgs.nodejs-20_x;
  # npm-global = toString ~/.npm-global;
  # ember = "${npm-global}/bin/ember";
  # pnpm = "${npm-global}/bin/pnpm";
  name = "rdfdiff";
  root = ''"$PRJ_ROOT"'';
in
pkgs.devshell.mkShell {
  inherit name;
  packages = [
    pkgs.jre8

  ];
  env = [
    # {
    #   name = "NPM_CONFIG_PREFIX";
    #   value = npm-global;
    # }
    # {
    #   name = "PATH";
    #   prefix = "${npm-global}/bin";
    # }
  ];
  commands = [
    # {
    #   name = "npm";
    #   help = "The node package manager";
    #   package = node_package;
    # }
    # {
    #   name = "node";
    #   help = "Nodejs";
    #   package = node_package;
    # }
    # {
    #   name = "ember";
    #   help = "The ember cli";
    #   command = ''${ember} "$@"'';
    # }
    # {
    #   name = "pnpm";
    #   help = "The pnpm package manager";
    #   command = ''${pnpm} "$@"'';
    # }
    # {
    #   name = "woodpecker-cli";
    #   help = "The Woodpecker cli";
    #   package = pkgs.woodpecker-cli;
    # }
    {
      name = "sbt";
      help = "the scala build tool";
      package = pkgs.sbt.overrideAttrs { postPatch = ""; };
    }

  ];
}
