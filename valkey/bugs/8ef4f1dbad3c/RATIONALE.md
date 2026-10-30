# Rationale

## Change (src/script.c, `scriptVerifyWriteCommandAllow`)
Removed the early return added by the fix:

    if ((run_ctx->flags & SCRIPT_WRITE_DIRTY)) return C_OK;

This reverses the single implementation hunk of fix.patch. The code moved/reformatted
in 9.0.7 (clang-format, "replica" naming), but the function and placement are the same:
right after the "not a write command" return and before the read-only-replica,
disk-error and `checkGoodReplicasStatus()` checks. Once a script has written, a later
write command is again subject to those state checks, so a replica dropping during a
long script makes the next write fail with NOREPLICAS, breaking atomicity.

## Oracle failure
"not enough good replicas state change during long script" fails: the script's second
`set` returns an error (NOREPLICAS) after the replica disconnects, so `$rd read` raises
instead of returning 1.
