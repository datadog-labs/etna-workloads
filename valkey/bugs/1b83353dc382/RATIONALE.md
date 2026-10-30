# Rationale

Fix hunk reversed: `commandProcessed()` in `src/networking.c`. The fix added an early
`if (blocked) return;` so a paused (blocked) replicated client neither advances
`reploff` nor propagates the unapplied stream to sub-replicas/backlog.

In 9.0.7 I removed that early return and restored the pre-fix structure: only
`reqresAppendResponse`/`clusterSlotStatsAddNetworkBytesIn`/`resetClient` are guarded by
`!c->flag.blocked`. The offset update and sub-replica propagation now run for blocked
clients again, so a paused replica's `slave_repl_offset` grows with commands it has not applied.

The other hunks (blockClient assert, `slave_read_repl_offset` in INFO) are not
behavioural for the bug and were left in place (the INFO field is needed by the test).

Oracle failure: `Test when replica paused, offset would not grow`
(`slave_repl_offset` != master offset before the paused write).
