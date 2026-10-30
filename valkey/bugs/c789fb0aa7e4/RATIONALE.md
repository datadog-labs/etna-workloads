# Rationale

## Change
`src/cluster.c` (getNodeByQuery, ~line 1227): removed `LOOKUP_NOEXPIRE` from the
lookup flags used for keys in a migrating/importing slot:

    int flags = LOOKUP_NOTOUCH | LOOKUP_NOSTATS | LOOKUP_NONOTIFY;

This reverses the fix's `cluster.c` hunk, which added `LOOKUP_NOEXPIRE`. The
other hunks (the flag definition, `EXPIRE_AVOID_DELETE_EXPIRED`, and the
`expireIfNeeded` handling) already exist in 9.0.7 (db.c, expire.c, server.h) and
are still used by other callers, so only the cluster.c call site is reverted.

## Effect
With the flag gone, `lookupKeyReadWithFlags` in getNodeByQuery can lazily
delete an expired key while processCommand is only deciding whether to
redirect (-ASK). The deletion is queued for propagation outside `call()`, so
the propagation queue isn't flushed and the assertion in beforeSleep trips.

## Oracle
All four cases in `tests/unit/cluster/misc.tcl` are reported failing. The
cause is the server crash/assert in "Key lazy expires during key migration"
(`R 0 GET FOO` on an expired key in a MIGRATING slot), which aborts the file,
so the other three cases are reported as failing too. With the change
reverted, check.sh reports 0 of 4 failing.
