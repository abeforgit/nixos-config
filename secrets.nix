let
  finch =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH77rNEmdExGH3PS71KzfiKy3KMXJlEww+CzWkVnBOKc root@finch";
  hosts = [ finch ];
  arne =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJi650EoFD+4UzbpQWrAcjCNK97KM+8SX12h+5oI/82O agenix-user";
  users = [ arne ];
in {
  "secrets/spotify.age".publicKeys = hosts ++ users;
  "secrets/authorized_keys/arne.age".publicKeys = hosts ++ users;
  "secrets/authorized_keys/root.age".publicKeys = hosts ++ users;
  "secrets/github_auth.age".publicKeys = hosts ++ users;
}
