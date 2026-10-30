Starts a primary and a replica, resets stats on the primary, does a SET, waits for the replica to have it, then checks `total_net_repl_output_bytes` on the primary.
Clean: the value is > 0. Buggy: it stays 0, because postWriteToReplica no longer updates the stat.
