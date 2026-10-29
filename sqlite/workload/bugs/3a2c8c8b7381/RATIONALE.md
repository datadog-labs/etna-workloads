# Rationale

Fix 3a2c8c8b (SQLite #3027) changed `sqlite3Prepare()` in two ways; both are reverted in `tree/src/prepare.c`.

1. Condition guarding the copy path. The fix changed `zSql[nBytes]!=0` (an out-of-bounds read of the byte
   one past the caller's buffer) to `zSql[nBytes-1]!=0`. In 3.54.1 this reads
   `nBytes>=0 && (nBytes==0 || zSql[nBytes-1]!=0)`. Restored to `nBytes>=0 && zSql[nBytes]!=0`.
   When the caller passes nBytes == length including the NUL, this reads past the end of the buffer.
2. `*pzTail` computation. The fix computes zTail from the parser's position inside the copy
   (`&zSql[sParse.zTail-zSqlCopy]`), and only uses `&zSql[nBytes]` if the copy failed (OOM).
   Restored the old unconditional `sParse.zTail = &zSql[nBytes];` so the tail points at the end of the input
   rather than after the first statement.

## Oracle results
`./check.sh`: no oracle case fails (capi3, crash7, vacuum3: 0 failing). The defect is an out-of-bounds read
(only visible under valgrind/ASAN, e.g. test_prepare_v2 uses an exact-size malloc copy for that purpose) and
the tail error only occurs when a non-NUL-terminated buffer holds several statements and the tests don't
exercise that without the harness clamp (`strlen(zTail)<bytes` in test1.c). So the bug is reintroduced
faithfully but is not detected by the plain oracle build.
