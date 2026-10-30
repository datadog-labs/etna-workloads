Master with a replica, min-replicas-to-write 1, lua-time-limit 10. An EVAL does a write, then loops
on INFO until the replica drops (we make the replica `replicaof no one` while the script is busy),
then does a second write.
Clean: the second write is allowed after the script is dirty -> reply 1, x="after".
Buggy: the SCRIPT_WRITE_DIRTY bypass is gone, so the second write fails with NOREPLICAS and
x stays "script value" (script aborted midway after a write).
