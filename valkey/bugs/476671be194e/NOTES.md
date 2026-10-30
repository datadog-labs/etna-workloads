Reproducer for the "replica can't finish failover when config epoch is outdated" bug (#2178).

repro.sh builds a 3-primary + 1-replica cluster, makes the replica drop all cluster packets,
bumps primary 0's config epoch (propagates to the other primaries but not the replica), then
SIGSTOPs primary 0 and retries `CLUSTER FAILOVER FORCE` on the replica.

Clean: the voting primaries deny the first attempt but send the replica an UPDATE, so a later
attempt succeeds -> `replica promoted: yes`.
Buggy: no UPDATE is sent, the replica's epoch stays stale and every attempt is denied ->
`replica promoted: no`.
