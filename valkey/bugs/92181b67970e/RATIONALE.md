# Rationale

Fix: Valkey #1131 added `server.server_del_keys_in_slot`, set during `delKeysInSlot`, and allowed it in the `propagateNow` assert. This stops the assert firing when a primary loses a slot while replica actions are paused.

Hunks reversed (in 9.0.7):
- `src/server.c` `propagateNow`: the assert is back to the pre-fix condition, `!isPausedActions(PAUSE_ACTION_REPLICA) || server.client_pause_in_transaction`. The `|| server.server_del_keys_in_slot` exception is dropped. This reverses the fix's server.c hunk. The assert was reformatted after the fix, so a plain reverse patch doesn't apply.
- `src/cluster_legacy.c` `delKeysInSlot`: removed the `server.server_del_keys_in_slot = 1` / `= 0` assignments (the fix's cluster_legacy.c hunks). With the flag never set, the assert exception is dead either way. The field in server.h stays, and so does the explanatory comment in propagateNow, because the other fix hunks only touch declarations and comments.

Result: when a primary loses a slot during a shutdown wait, a manual failover pause or a CLIENT PAUSE, `delKeysInSlot` propagates DEL while `PAUSE_ACTION_REPLICA` is active. That trips the `propagateNow` assert and crashes the primary.

Oracle: `./check.sh` aborted in tests/unit/cluster/slot-ownership.tcl with an exception from start_cluster when the "Primary lost a slot during the manual failover pausing" test ran, which fits a primary crashing on the assert. I didn't see the per-case FAIL summary for that file because the output I read was cut off. tests/unit/pause.tcl is unaffected, with 0 of 23 cases failing.
