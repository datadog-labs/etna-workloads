Reproducer: sets a key with PX 3, then CLIENT PAUSE 10000 WRITE in the same MULTI/EXEC, waits for the key to expire, and runs RANDOMKEY (3s client timeout).
Clean: replies "key". Buggy: the injection drops the isPausedActions(PAUSE_ACTION_EXPIRE) check in randomkey, so the server loops forever; the CLI times out ("randomkey hung").
