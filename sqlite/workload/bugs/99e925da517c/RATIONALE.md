# Rationale

Fix hunk (src/vdbeblob.c): `sqlite3VdbeChangeP2(v, 8, pTab->nCol);` set the P2 of the
OP_Column in the blob-open program to `nCol`, i.e. the imaginary extra column that is
always NULL, so no row data is read. Before the fix P2 stayed 0, so OP_Column read the
leftmost column (possibly a huge blob, which is then malloc'd in full).

In 3.54.1 the same assignment is `aOp[3].p2 = pTab->nCol;` in sqlite3_blob_open()
(src/vdbeblob.c). I removed that line, so OP_Column in the openBlob program keeps P2=0 and
reads the leftmost column again. (The OP_OpenRead nCol+1 setting is untouched, as in the
original pre-fix code.)

## Oracle failures
test/incrblob2.test: 65 of 80 oracle cases fail, including 7.2 and 7.4 (the memory
highwater checks the fix added: opening a blob now allocates the 10MB leftmost blob),
plus many others (1.x, 2.x, 3.x, 4.x, 6.x, 8.x).
