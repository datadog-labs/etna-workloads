Creates an fts4 table with 3 columns, an fts4aux table over it, and inserts a row with a term only in column c2 (column index 3 in the doclist, past nColumn+1... of the buggy check).
Fixed/clean shell returns `x|*|1|1` and `x|2|1|1`. The buggy shell's column-number bound check `iCol>nColumn+1` spuriously returns SQLITE_CORRUPT_VTAB ("database disk image is malformed").
