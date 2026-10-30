Starts a 3-primary cluster (AOF on, so propagateNow actually propagates), sets FOO, runs
`CLIENT PAUSE ... WRITE` on the owner, then has another node claim FOO's slot via
bumpepoch + setslot. The owner deletes keys in the dirty slot while paused.
Clean: the node survives and answers PING. Buggy: the assert in propagateNow fails
(server_del_keys_in_slot no longer set), node aborts, PING gets connection refused, "ASSERTION" printed.
