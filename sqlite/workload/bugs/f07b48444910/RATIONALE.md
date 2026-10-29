# Rationale

## Change
`tree/src/wherecode.c` (~line 1878, rowid-range loop "Case 3"): the end-of-range
comparison `testOp` on the rowid had `P5 = SQLITE_AFF_NUMERIC | SQLITE_JUMPIFNULL`;
it is now `SQLITE_AFF_NUMERIC`.

Reverses the single implementation hunk of the fix (src/where.c), which changed
`SQLITE_AFF_NUMERIC` to `SQLITE_AFF_NUMERIC|0x100` (0x100 is today's
SQLITE_JUMPIFNULL) on the rowid-vs-limit compare. Without the flag, a NULL
bound makes the comparison fall through instead of jumping out of the loop,
so rowid comparisons against NULL (ticket #2404) don't terminate the scan.

## Oracle failures
`where5-3.6` and `where5-3.7` (`SELECT * FROM t3 WHERE x<NULL` / `x<=NULL` on an
INTEGER PRIMARY KEY table) return `-1 0 1` instead of an empty result.
