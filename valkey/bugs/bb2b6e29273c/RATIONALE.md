# Rationale

## Changed hunk
`src/script.c`, `scriptVerifyClusterState()`: removed the final `original_c->slot = hashslot;`.

Reverses the fix hunk that added `c->slot = hashslot; original_c->slot = hashslot;` at the end of
`scriptVerifyClusterState`. In 9.0.7 the `run_ctx->slot` tracking, `scriptPrepareForRun`/`scriptResetRun`
hunks, `c->slot = ...` assignment (line from clusterSlotByCommand), and the sort/pubsub `getKeySlot`
changes are already present; only the update of the caller's (current client's) slot remains, so
removing it restores the bug: `getKeySlot()` returns the cached slot of the pre-declared key instead
of the slot of the key the script command actually touches.

## Oracle failures
`Cross slot commands are allowed by default if they disagree with pre-declared keys` fails (the key lands in
the wrong slot / debug assert in getKeySlot), and the run crashes on the debug assertion
(`keyHashSlot(key) == current_client->slot`), so later cases (cluster shards/slots, no-cluster flag tests)
also fail as an incomplete run.
