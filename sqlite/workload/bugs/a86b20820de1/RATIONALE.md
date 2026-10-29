# Rationale

Bug: fts3PoslistMerge() looped forever on a corrupt doclist containing a POS_COLUMN
entry with column number 0 (column 0 is never written explicitly, so this is corrupt).

## Change (ext/fts3/fts3.c, fts3PoslistMerge)
Removed the two `if( iColN==0 ) return FTS_CORRUPT_VTAB;` checks added by the fix
(hunk 2 of fts3.c). With iCol1==iCol2==0 on a POS_COLUMN byte, the merge loop makes
no progress. The int return type / `rc` propagation in fts3DoclistOrMerge (hunks 1, 3-5)
is left in place; it is inert without the checks, so behaviour equals pre-fix.

The fts5 undefined left shift (fts5_buffer.c) was not reverted: it is UB only, with no
reliable observable failure, and is not the main defect.

## Oracle
test/fts3corrupt4.test case 12.x (corrupt db) hangs/loops forever in the OR doclist merge
instead of returning "database disk image is malformed".
