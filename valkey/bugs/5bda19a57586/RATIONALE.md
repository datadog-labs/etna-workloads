# Rationale

Hunk reversed: `clusterSlotMigrationCron` in `src/cluster_migrateslots.c` (fix hunk @@ -2197).

9.0.7 already had the fixed structure: ACK sent *after* `proceedWithSlotMigration(job)`, with the
`timer_already_refreshed` optimisation. I restored the pre-fix form: the ACK
(`if (canSlotMigrationJobSendAck(job)) run_with_period(1000) sendSyncSlotsMessage(job, "ACK");`)
goes back inside the timeout-check block, before `proceedWithSlotMigration`, and the post-proceed
ACK block is removed. With hz 1 the cron runs once per second, so the ACK fires every loop,
before the main logic; the snapshot never proceeds.

Oracle: "Import with hz set to 1" fails, along with most of cluster-migrateslots.tcl
(86 of 98 cases; the run is incomplete, with a crash/assert/timeout). The test file errors out
during cluster startup in the log above, so these failures may not all come from the hz 1 mechanism.
