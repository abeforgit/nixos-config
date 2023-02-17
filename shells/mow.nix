{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-18_x;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  name = "mow";
  root = ''"$PRJ_ROOT"'';
  frontend = "${root}/frontend-mow-registry";
  backend = "${root}/app-mow-registry";
  port = "4600";
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
      name = "COMPOSE_FILE";
      value =
        "docker-compose.yml:docker-compose.dev.yml:docker-compose.override.yml";
    }
    {
      name = "WOODPECKER_SERVER";
      value = "https://build.redpencil.io";
    }
    {
      name = "EMBER_SIMPLE_LOGIN";
      value = "false";
    }
    {
      name = "EMBER_ACM_API_KEY";
      value = "ae3be0bb-5c5d-447f-9916-1ea819267e53";
    }
    {
      name = "EMBER_BASE_URL";
      value = "https://roadsigns/lblod.info";
    }
    {
      name = "EMBER_ACM_BASE_URL";
      value= "https://authenticatie-ti.vlaanderen.be/op/v1/auth";
    }
    {
      name = "EMBER_ACM_REDIRECT_URL";
      value = "https://roadsigns.lblod.info/authorization/callback";
    }
    {
      name = "EMBER_LOGOUT_URL";
      value = "https://authenticatie-ti.vlaanderen.be/op/v1/logout";
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
        ${ember} s --port=${port} --proxy=http://localhost:4602
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
