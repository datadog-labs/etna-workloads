# Rationale

Fix: drh 2024-03-04, track UTC vs localtime in DateTime (isUtc/isLocal) and make the 'utc'/'localtime' modifiers no-ops when already in that zone.

Changes in tree/src/date.c:

1. `localtime` modifier: `rc = p->isLocal ? SQLITE_OK : toLocaltime(p, pCtx);` -> `rc = toLocaltime(p, pCtx);`
   Reverses the fix hunk in parseModifier that made repeated 'localtime' a no-op. Pre-fix, every 'localtime' shifted the time again.
2. `setDateTimeToCurrent`: removed `isUtc=1; isLocal=0; clearYMD_HMS_TZ()`. Reverses the fix hunk that marked 'now' as UTC. Pre-fix, 'now' was not known to be UTC, so a following 'utc' modifier converted it again (the tkt-bd484a090c change from 'now' to a literal date reflects this).

(The rest of the fix, isUtc replacing tzSet/validTZ, is already structurally in place; only the no-op behaviours were reverted.)

Oracle failure: test/date.test date-6.32 (`datetime('2000-10-29 12:00:00Z','localtime','localtime')` gives 13:00:00 instead of 12:30:00). The tkt-bd484a090c cases still pass (the fault there errors out either way).
