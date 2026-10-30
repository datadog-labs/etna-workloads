repro.sh starts a server and runs `COMMAND GETKEYS SORT abc STORE def` (plus a multi-STORE variant).
Clean returns both keys (abc, def); buggy drops the STORE key and returns only abc,
because sortGetKeys no longer counts the found STORE key in numkeys.
