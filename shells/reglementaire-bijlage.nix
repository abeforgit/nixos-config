{ pkgs, inputs }:
let
  node_package = pkgs.nodejs-16_x;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  port = "4500";
  name = "reglementaire-bijlage";
  root = ''"$PRJ_ROOT"'';
  frontend = "${root}/frontend-reglementaire-bijlage";
  backend = "${root}/app-reglementaire-bijlage";
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
      name = "up-backend";
      help = "Start the development backend";
      command = ''
        pushd ${backend}
        docker-compose -f docker-compose.yml -f docker-compose.dev.yml -f docker-compose.override.yml up -d
        popd
      '';
    }
    {
      name = "up-frontend";
      help = "Start the development server";
      command = ''
        pushd ${frontend}
        ${ember} s --port=${port} --proxy=http://localhost:4502
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

  ];
}
