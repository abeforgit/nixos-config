{ pkgs, inputs }:
let name = "rust";
in pkgs.devshell.mkShell {
  inherit name;
  commands = [
    {
      name = "cargo";
      help = "Rust build tool";
      package = pkgs.cargo;
    }
  ]

}
