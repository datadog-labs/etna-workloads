repro.sh starts a server and runs CONFIG SET slot-migration-max-failover-repl-bytes -1, then CONFIG GET, then CONFIG SET -2.
Clean: -1 is accepted and read back as -1, and -2 gives a 'between -1 and ...' range error.
Buggy: -1 is rejected with 'argument must be a memory value', and CONFIG GET returns 0.
