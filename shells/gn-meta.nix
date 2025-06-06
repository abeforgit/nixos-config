{ pkgs, inputs }:
let
  oldpkgs = import (builtins.fetchTarball {
    url = "https://github.com/NixOS/nixpkgs/archive/7a339d87931bba829f68e94621536cad9132971a.tar.gz";
  }) { };

  node_package = pkgs.nodejs_22;
  pnpm = pkgs.pnpm;
  yalc = pkgs.nodePackages.yalc;
  # node_package = pkgs.nodejs_20;
  npm-global = toString ~/.npm-global;
  ember = "${npm-global}/bin/ember";
  name = "gn-meta";
  root = ''"$PRJ_ROOT"'';
  wpPkgs = import (builtins.fetchGit {
    # Descriptive name to make the store path easier to identify
    name = "my-old-revision";
    url = "https://github.com/NixOS/nixpkgs/";
    ref = "refs/heads/nixpkgs-unstable";
    rev = "7a339d87931bba829f68e94621536cad9132971a";
  }) { };

  woodpecker = wpPkgs.woodpecker-cli;
in
pkgs.devshell.mkShell {
  inherit name;
  packages = with pkgs; [
    # playwright-test
    krb5
    krb5.dev
    gnumake
    gcc
    pkgs.stdenv.cc
    openssl
    jdk
    maven
  ];

  packagesFrom = with pkgs; [
    # playwright-driver.browsers
  ];
  env = [
    {
      name = "NIX_LD_LIBRARY_PATH";
      value = pkgs.lib.makeLibraryPath [
        pkgs.stdenv.cc.cc
        pkgs.libgit2
        pkgs.openssh_gssapi
        pkgs.openssl
        pkgs.libkrb5.dev
        pkgs.libgcc
        pkgs.glibc.dev

      ];
    }
    {
      name = "NIX_LD";
      value = pkgs.lib.fileContents "${pkgs.stdenv.cc}/nix-support/dynamic-linker";
    }
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
    # {
    #   name = "PLAYWRIGHT_BROWSERS_PATH";
    #   value = pkgs.playwright-driver.browsers;
    # }
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
    # {
    #   name = "pw";
    #   command = ''rm -r node_modules/@playwright || true ; ${pkgs.playwright-test}/bin/playwright "$@"'';
    # }
    {
      name = "yarn";
      package = pkgs.yarn;
    }
    {
      name = "woodpecker-cli";
      help = "The Woodpecker cli";
      package = woodpecker;
    }

  ];
}
