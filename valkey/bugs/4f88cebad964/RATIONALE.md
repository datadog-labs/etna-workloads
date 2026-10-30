# Rationale

9.0.7 already contained most of the fix (hashTypeSet's `expired_overwritten` out-param, notifications, HSETEX propagation), so a plain reverse of fix.patch does not apply. I reverted only the replication hunks, all in `src/t_hash.c`.

1. `hincrbyCommand`: removed the `if (has_volatile_fields) { ... HSET/HSETEX rewrite ... }` block. This reverses the fix hunk that added it. HINCRBY is again propagated as-is, so a replica that holds an expired-but-unreaped field increments the stale value, or errors if it isn't an integer. This is issue 1 in the commit message.
2. `hincrbyfloatCommand`: replaced the `expiry == EXPIRY_NONE ? HSET : HSETEX PXAT` branch with the old unconditional HSET rewrite, including the old comment text. This reverses the fix hunk that added the HSETEX branch. The replica loses the field TTL. This is issue 2 in the commit message.

## Oracle failures (tests/unit/hashexpire.tcl)
- "HINCRBY is executed on repilca's expired fields": the replica's `hget` returns '' instead of 1.
- "HINCRBYFLOAT maintains TTL on repilca's fields": the replica's HPEXPIRETIME is -1 (TTL lost) while the primary has the TTL.
