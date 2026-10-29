# Rationale

## Change: src/pager.c, sqlite3PagerOpen()
Reverses the single implementation hunk of the fix. The fix hoisted the
`iDc` computation out of the `if( !readOnly )` block and moved the `nolock`
URI handling and the `SQLITE_IOCAP_IMMUTABLE` check outside it. In 3.54.1 the
code is already hoisted (the `immutable` URI parameter is now handled earlier
via `bImmutable`, so it is not reverted). I moved the `pPager->noLock = ...`
assignment and the `SQLITE_IOCAP_IMMUTABLE` check back inside `if( !readOnly )`,
the pre-fix placement. `iDc` stays hoisted, which is harmless.

## Oracle failures
- nolock-1.4: `nolock=1` with a read-only open still takes locks (xLock 2 instead of 0).
- nolock-3.12: a VFS reporting IOCAP_IMMUTABLE with a read-only open still locks and calls xAccess.
