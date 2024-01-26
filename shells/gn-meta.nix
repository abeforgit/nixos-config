{ pkgs, inputs }:
let
  pnpm = pkgs.nodePackages.pnpm;
  yalc = pkgs.nodePackages.yalc;
  node_package = pkgs.nodejs_20;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  name = "gn-meta";
  root = ''"$PRJ_ROOT"'';
in pkgs.devshell.mkShell {
  inherit name;
  packages = with pkgs; [ cypress playwright-test ];
  packagesFrom = with pkgs; [ cypress playwright-driver.browsers ];
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
    {
      name = "PLAYWRIGHT_BROWSERS_PATH";
      value = pkgs.playwright-driver.browsers;
    }
    {
      name = "PLAYWRIGHT_SKIP_VALIDATE_HOST_REQUIREMENTS";
      value = true;
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
    {
      name = "cypress";
      help = "The cypress cli";
      package = pkgs.cypress;
    }
    {
      name = "pw";
      command =
        ''rm -r node_modules/@playwright || true ; ${pkgs.playwright-test}/bin/playwright "$@"'';
    }
    # {
    #   name = "woodpecker-cli";
    #   help = "The Woodpecker cli";
    #   package = pkgs.woodpecker-cli;
    # }

  ];
}
