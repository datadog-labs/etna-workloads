Starts a 3-primary cluster (node 2 owns only slot 0), disables cluster-allow-replica-migration on node 2,
writes a key into slot 0, then makes node 0 take slot 0 via `cluster setslot 0 node` without migrating keys.
Node 2 becomes an empty primary and prints its `dbsize`.
Clean: dbsize 0 (dirty slot keys deleted). Buggy: dbsize 1 (the key is left behind, since delete_dirty_slots is never set).
