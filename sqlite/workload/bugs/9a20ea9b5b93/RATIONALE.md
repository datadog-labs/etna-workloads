# Rationale

## Hunk 1 (src/btree.c, btreeComputeFreeSpace): `pc<iCellFirst` -> `pc<top`
Reversed at line ~2155: the "first freeblock must lie after the cell content
area start" check is back to comparing against `iCellFirst` (end of the cell
pointer array) instead of `top` (start of the cell content area). A freeblock
that lies in the unallocated gap between the two is accepted again, inflating
`nFree`. In 3.54.1 the line already read `pc<top`, so this is a direct reversal.

## Additional change: removed the `size<4` freeblock check (same function)
Reversing the hunk alone does not bring the bug back: 3.54.1 has a later
hardening check (`size<4 && sqlite3FaultSim(422)==SQLITE_OK`) that rejects
the same corrupt pages (the fix's freeblock at 0x770 is zero-filled, size 0).
That check did not exist when the bug was fixed (2020-01-03), so I removed it
so the pre-fix behaviour is observable. This is a judgement call: it is a
separate defence, not part of the fix's hunk, but it is what covers the case
on a different path in the same function.

## Oracle
test/fts3corrupt4.test fails 12 cases (24.1, 24.3, 24.5, 27.2-27.6, 28.1, 28.3,
28.5, 28.7): inserts that should report "database disk image is malformed"
now succeed ({0 {}}), the exact expectations the fix changed.
corruptL-13.x still passes (it already returned malformed through other checks).
