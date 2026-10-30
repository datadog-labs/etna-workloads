repro.sh starts a master and a replica (active expire disabled on both), syncs them, then does
SADD s foo; PEXPIRE s 1; sleep; SADD s foo (lazy expire on the master), WAIT 1 0, and prints TYPE s on both.
Clean: replica reports `set`. Buggy: the replication stream orders the SADD before the lazy-expire DEL
(placeholder), so the replica ends with `none`.
