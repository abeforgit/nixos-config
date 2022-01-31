let
  finch =
    "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINii0z6bDY+XIpxbvbHNTaRvjcSzCaPJ/PA7jE7Dq2H2 finch";
  hosts = [ finch ];
  arne =
    "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAACAQDIo6J0tgjkOiE+2aePvWWZ9MbbZkgT99UA8cHSStcPw/2jTT4eyQy2bpKFHyxYWpAd4hYPJwEmxVHbGC7v9Xrkz37JXS23gX8H/OAuD83glo62B8HXeagLLOruY8s8MRGanSi/1JSF85xd7yplcCiCwd4ixL/OWGNsyDMblkYhDPh9YDCnYES9s8fT1Kpfu1EPacNetw2KMVIWYP6hpagaLVoDYBd85OnWzmipQmD4E2Ma20SLVrMDVQKtYM3fCR/bzQfVz/nMk3+IICbMDkd8/f1Wgo0TDW6YsB2Gdt6jeiORzpCcMS+dd+mHJU3iMT4LzqP2yVsMb7xkKeI8IsWn5VGPvxMAimuWFjsAmqMlbl/AgMct5ka4JwfODMDgwoLdP88/yTj2kiI7wxnXPeOHLcmGNDZ0vL1+hvQwLoYMrgO3Jun1qW2G9hN5Xps0AafuXwxZup08hKDLYhARSJ97zvkA65nfWlAn+5OR58RzAWYO8vw8//kkLq07UBv9Z+VWbkGMLimXQeWHwMWDN9MwdmGwdULp1yBMSZKOB9j0rOcyQILQOJ0KVkneRAIs7D/IWN5SHi6SwsZVrUbpJLix00i620xl6QHdQMV3+RXRiffkaI/6x7bvvxheISZndAf4cANBYQoKc36cvcXQO9z52cN6ONKYDlqnQnyeKxmf8Q== arnebertrand@gmail.com";
  users = [ arne ];
in {
  "secrets/spotify.age".publicKeys = hosts ++ users;
}
