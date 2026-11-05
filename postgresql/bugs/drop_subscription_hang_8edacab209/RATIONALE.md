# Rationale

## src/backend/commands/subscriptioncmds.c, DropSubscription()
Traces to the single implementation hunk of fix.patch (worker-stop loop in DropSubscription).
The fix stops all subscription workers immediately and unconditionally. The reverse restores the
old `if (slotname) stop` condition. `logicalrep_worker_stop_at_commit` no longer exists in
REL_18_6, so the old `else` branch (deferring the stop to commit) is expressed as not stopping the
workers immediately. When a subscription is disabled and dropped in the same transaction (no
slot), the apply worker is still running and the later replication origin drop waits on it, so
DROP SUBSCRIPTION hangs.

## Failing oracle cases
All 8 cases in src/test/subscription t/007_ddl.pl fail (reported 'missing': the script hangs at
the disable+drop step and times out, so no later results are produced), including
"subscription disable and drop in same transaction did not hang", plus the 7 other cases listed
in oracle.json.
