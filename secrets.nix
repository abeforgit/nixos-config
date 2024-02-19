let
  finch =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH77rNEmdExGH3PS71KzfiKy3KMXJlEww+CzWkVnBOKc root@finch";
    sparrow = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKxZZMfrNSAh8tgD099m6iQ1GwAZYiNbJPnVGUJV0Ugu root@sparrow";
  hosts = [ finch sparrow ];
  arne =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJi650EoFD+4UzbpQWrAcjCNK97KM+8SX12h+5oI/82O agenix-user";
  users = [ arne ];
in {
  "secrets/spotify.age".publicKeys = hosts ++ users;
  "secrets/authorized_keys/arne.age".publicKeys = hosts ++ users;
  "secrets/authorized_keys/root.age".publicKeys = hosts ++ users;
  "secrets/github_auth.age".publicKeys = hosts ++ users;
  "secrets/gn_prod_backup.age".publicKeys = hosts ++ users;
  "secrets/jira_pat.age".publicKeys = hosts ++ users;
}
