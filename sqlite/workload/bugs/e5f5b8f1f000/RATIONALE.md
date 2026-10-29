# Rationale

Fix (CVS 4930) changed `if( isMinQuery && !topLimit )` to
`if( isMinQuery && bRev && !topLimit )` in `sqlite3WhereBegin`. Before it, a
min() query added a NULL terminator to the end-of-range key even on a forward
scan, so `SELECT min(b) FROM t WHERE a=1 AND b>1` stopped at the NULL entries
and returned nothing.

In 3.54.1 that code lives in `src/wherecode.c` (`sqlite3WhereCodeOneLoopStart`).
The NULL terminator is now `bStopAtNull`, which is normally set only through
`bSeekPastNull` and the start/end swap for reverse scans. I re-added the old
unconditional behaviour: right after the swap, a `WHERE_ORDERBY_MIN` loop with
a range start, no range end and a nullable index column at `nEq` sets
`bStopAtNull=1` without checking `bRev`. The existing `bStopAtNull` code then
appends the NULL end key.

I could not map the old `topLimit` and `bRev` conditions onto the new code
one-to-one. The condition I used is my reconstruction of what the old code did
in the failing cases, not a literal reversal of the hunk.

The `vdbemem.c` and manifest hunks are comments and metadata only, so I did not
touch them.

## Oracle failures
minmax3-2.3, 2.4, 3.3 and 3.4 fail. For example, `min(b) ... a=1 AND b>-1`
returns NULL instead of 1 (3.4 expects 1 and gets an empty result).
