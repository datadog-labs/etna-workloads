# Rationale

## src/backend/access/transam/xlogrecovery.c, check_recovery_target_xid()
Traces to the single guc.c hunk of fix.patch (strtoul -> pg_strtouint64; the code
has since moved to xlogrecovery.c and uses strtou64). Reverted to strtoul().
Since unsigned long is 64-bit on this Linux build, I emulate the 32-bit-`unsigned long`
platforms (Windows) by flagging ERANGE when the value exceeds UINT32_MAX. A target XID
carrying a nonzero epoch (e.g. from pg_current_xact_id()) is then rejected instead of
being truncated to 32 bits.

## Failing oracle cases
The 003_recovery_targets.pl XID case (epoch bumped via pg_resetwal) fails, and the
dependent cases in that file may fail too.

Oracle result: 8 of 9 fail (all of 003_recovery_targets.pl except "immediate target"),
because the test aborts at the XID step (the server rejects the epoch-bearing
recovery_target_xid), so later cases are missing. Failing: LSN, XID, multiple overriding
settings, name, time, invalid recovery startup fails, multiple conflicting settings,
recovery end before target reached is a fatal error.
