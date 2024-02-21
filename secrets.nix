let
  finch =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH77rNEmdExGH3PS71KzfiKy3KMXJlEww+CzWkVnBOKc root@finch";
  sparrow =
  "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIH4mUuSDUbft1Gqsn3S6jR0pe9y2YvFKRJ02pjRgM33P root@sparrow";
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
