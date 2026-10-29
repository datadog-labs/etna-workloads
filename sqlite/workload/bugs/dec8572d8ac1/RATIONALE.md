# Rationale

Fix hunk: `ext/misc/carray.c` `memcpy(pNew->aData, aData, sz*nData)` -> `memcpy(..., sz)`.
In 3.54.1 the code lives in `src/carray.c` (sqlite3_carray_bind_v2). There `sz` is already
multiplied by the element size and nData in the SQLITE_TRANSIENT branch, so I restored the
pre-fix `memcpy(pNew->aData, aData, sz*nData)` at the numeric-array else branch (line 522).
This copies nData times too many bytes: heap buffer overflow on the destination and an
over-read of the source.

Oracle: test/carray01.test, case carray01-121 (int64, -transient) crashes with a heap
corruption abort ("malloc(): mismatching next->prev_size"); the later cases then fail as the run is incomplete.
