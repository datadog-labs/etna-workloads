Reproducer: stream-node-max-entries=2, add 3 entries (nodes of 2 and 1), then XTRIM MAXLEN ~ 0 LIMIT 1.
Clean: returns 0 (deleting the 2-entry node would exceed the limit); buggy: deletes the whole node and returns 2, XLEN drops to 1.
