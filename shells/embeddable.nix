{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-16_x;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  port = "4600";
  name = "embeddable";
  root = ''"$PRJ_ROOT"'';
  frontend = "${root}/frontend-embeddable-notule-editor";
  backend = "${root}/app-gn-embeddable";
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
    {
      name = "WOODPECKER_SERVER";
      value = "https://build.redpencil.io";
    }
  ];
  commands = [
    {
      name = "up-backend";
      help = "Start the development backend";
      command = ''
        pushd ${backend}
        docker-compose up -d
        popd
      '';
    }
    {
      name = "down-backend";
      help = "Stop the development backend";
      command = ''
        pushd ${backend}
        docker-compose down
        popd
      '';
    }
    {
      name = "up-frontend";
      help = "Start the development server";
      command = ''
        pushd ${frontend}
        ${ember} s --port=${port}
        popd
      '';
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
    # {
    #   name = "woodpecker-cli";
    #   help = "The Woodpecker cli";
    #   package = pkgs.woodpecker-cli;
    # }

  ];
}
