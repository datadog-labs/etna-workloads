Reproducer: XADD otherstream 0-0 k v, then EXISTS/DBSIZE. Clean rejects early (no key); buggy creates an empty stream key.
